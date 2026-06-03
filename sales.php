<?php
declare(strict_types=1);

/** Workstation — sale management (Phase 4 post-sale ops).
 *  /sales.php            → recent sales list + search (voucher no. / customer)
 *  /sales.php?id=N       → sale detail: items, totals, status, voucher, audit trail,
 *                          + post-sale actions (slice 1: Cancel sale).
 *  POST do=cancel        → cancel a paid sale (reason mandatory; admin PIN escalation
 *                          if the ticket date has already passed). Voids the voucher.
 *  Authority per §3.4; every action writes to audit_log (§4.2). Customer amounts only. */

define('PTI_BASE', __DIR__ . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
if (!Auth::isStation() || Auth::expired()) { redirect("/"); }

$a      = Auth::actor();
$tenant = Auth::tenantById((int) $a['tenant_id']);
$tid    = (int) $a['tenant_id'];

function czk($n): string { return number_format((float) $n, 0, ',', "\u{00A0}") . "\u{00A0}Kč"; }
function eur($n): string { return $n === null ? '' : number_format((float) $n, 0, ',', "\u{00A0}") . "\u{00A0}€"; }
$PM      = ['cash' => 'Hotovost', 'card' => 'Karta'];
$STBADGE = [
    'paid'      => ['Zaplaceno',   'ok'],
    'cancelled' => ['Stornováno',  'bad'],
    'refunded'  => ['Refundováno', 'warn'],
    'draft'     => ['Rozpracováno', 'muted'],
];
function st_badge(string $s, array $map): string {
    [$lbl, $cls] = $map[$s] ?? [$s, 'muted'];
    return '<span class="ps-status ' . $cls . '">' . e($lbl) . '</span>';
}

$id    = (int) ($_GET['id'] ?? ($_POST['sale_id'] ?? 0));
$flash = '';

/* ---------------------------------------------------------------- POST */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $id) {
    $sale = Database::all("SELECT * FROM sales WHERE id=? AND tenant_id=?", [$id, $tid])[0] ?? null;
    if (!$sale) { redirect('/sales.php'); }
    $do  = (string) ($_POST['do'] ?? '');
    $err = '';

    if ($do === 'cancel') {
        $reason = trim((string) ($_POST['reason'] ?? ''));
        if ($sale['status'] !== 'paid') {
            $err = 'Stornovat lze jen zaplacený prodej.';
        } elseif ($reason === '') {
            $err = 'Uveď důvod storna (povinné).';
        } else {
            // Cancellation policy proxy: if any item's ticket date already passed,
            // realisation is assumed → admin escalation required (§3.4).
            $past = (int) Database::scalar(
                "SELECT COUNT(*) FROM sale_items WHERE sale_id=? AND ticket_date IS NOT NULL AND ticket_date < CURDATE()",
                [$id]
            );
            $approver = null;
            if ($past > 0) {
                $pin = trim((string) ($_POST['admin_pin'] ?? ''));
                if ($pin === '') {
                    $err = 'Termín už proběhl – storno musí schválit admin PINem.';
                } else {
                    $approver = Auth::verifyEscalationPin($pin);
                    if (!$approver) { $err = 'Neplatný admin PIN (nebo dočasně zablokováno).'; }
                }
            }
            if ($err === '') {
                $pdo = Database::pdo();
                $pdo->beginTransaction();
                try {
                    $pdo->prepare("UPDATE sales SET status='cancelled', cancelled_at=NOW(), cancel_reason=? WHERE id=?")
                        ->execute([$reason, $id]);
                    $pdo->prepare("UPDATE vouchers SET status='voided' WHERE sale_id=? AND status='issued'")
                        ->execute([$id]);
                    $pdo->commit();
                } catch (Throwable $e) { $pdo->rollBack(); throw $e; }
                Audit::log('sale.cancel', 'sale', $id, [
                    'status'      => ['from' => 'paid', 'to' => 'cancelled'],
                    'voucher'     => $sale['voucher_number'],
                    'total_czk'   => $sale['total_czk'],
                    'realised'    => $past > 0,
                    'approved_by' => $approver['email'] ?? null,
                ], $reason);
                redirect('/sales.php?id=' . $id . '&ok=cancel');
            }
        }
    }

    if ($do === 'refund') {
        $reason = trim((string) ($_POST['reason'] ?? ''));
        $raw    = str_replace([' ', "\u{00A0}", ','], ['', '', '.'], (string) ($_POST['amount'] ?? ''));
        $amount = round((float) $raw, 2);
        $total  = (float) $sale['total_czk'];
        $already = (float) ($sale['refunded_czk'] ?? 0);
        $remain = round($total - $already, 2);
        if ($sale['status'] !== 'paid') {
            $err = 'Refundovat lze jen zaplacený (či částečně refundovaný) prodej.';
        } elseif ($reason === '') {
            $err = 'Uveď důvod refundace (povinné).';
        } elseif ($amount <= 0) {
            $err = 'Zadej částku refundace v Kč.';
        } elseif ($amount > $remain + 0.001) {
            $err = 'Maximální refundovatelná částka je ' . czk($remain) . '.';
        } else {
            $approver = null;
            if ($amount > 1500) { // §3.4 — refund above 1 500 Kč needs admin
                $pin = trim((string) ($_POST['admin_pin'] ?? ''));
                if ($pin === '') {
                    $err = 'Refundace nad 1 500 Kč musí schválit admin PINem.';
                } else {
                    $approver = Auth::verifyEscalationPin($pin);
                    if (!$approver) { $err = 'Neplatný admin PIN (nebo dočasně zablokováno).'; }
                }
            }
            if ($err === '') {
                $eurAmt = ($sale['total_eur'] !== null && $total > 0)
                    ? round((float) $sale['total_eur'] * $amount / $total, 2) : null;
                $commTotal = (float) Database::scalar(
                    "SELECT COALESCE(SUM(commission_czk),0) FROM sale_items WHERE sale_id=?", [$id]);
                $commRev  = $total > 0 ? round($commTotal * $amount / $total, 2) : 0.0;
                $newTotal = round($already + $amount, 2);
                $isFull   = $newTotal >= $total - 0.001;
                $kind     = $isFull ? 'full' : 'partial';
                $newEur   = $sale['total_eur'] !== null
                    ? round((float) ($sale['refunded_eur'] ?? 0) + ($eurAmt ?? 0), 2) : null;
                $pdo = Database::pdo();
                $pdo->beginTransaction();
                try {
                    $pdo->prepare("INSERT INTO refunds
                        (sale_id,actor_type,actor_id,approved_by_admin_id,kind,amount_czk,amount_eur,commission_reversed_czk,reason)
                        VALUES (?,?,?,?,?,?,?,?,?)")
                        ->execute([$id, $a['type'], (int) $a['id'], $approver['id'] ?? null,
                                   $kind, $amount, $eurAmt, $commRev, $reason]);
                    $pdo->prepare("UPDATE sales SET refunded_czk=?, refunded_eur=?, status=? WHERE id=?")
                        ->execute([$newTotal, $newEur, $isFull ? 'refunded' : 'paid', $id]);
                    $pdo->commit();
                } catch (Throwable $e) { $pdo->rollBack(); throw $e; }
                Audit::log('sale.refund', 'sale', $id, [
                    'kind'                     => $kind,
                    'amount_czk'               => $amount,
                    'refunded_total_czk'       => $newTotal,
                    'commission_reversed_czk'  => $commRev,
                    'approved_by'              => $approver['email'] ?? null,
                ], $reason);
                redirect('/sales.php?id=' . $id . '&ok=refund');
            }
        }
    }

    if ($do === 'reissue') {
        $reason = trim((string) ($_POST['reason'] ?? ''));
        if ($sale['status'] !== 'paid' || empty($sale['voucher_number'])) {
            $err = 'Nový voucher lze vystavit jen u zaplaceného prodeje s aktivním voucherem.';
        } else {
            $pin = trim((string) ($_POST['admin_pin'] ?? ''));
            if ($pin === '') {
                $err = 'Vystavení nového voucheru musí schválit admin PINem.';
            } else {
                $approver = Auth::verifyEscalationPin($pin);
                if (!$approver) { $err = 'Neplatný admin PIN (nebo dočasně zablokováno).'; }
            }
            if ($err === '') {
                $oldNum = (string) $sale['voucher_number'];
                $pdo = Database::pdo();
                $pdo->beginTransaction();
                try {
                    $st = $pdo->prepare("SELECT id, language FROM vouchers WHERE sale_id=? AND status='issued' ORDER BY id DESC LIMIT 1");
                    $st->execute([$id]);
                    $cur  = $st->fetch(PDO::FETCH_ASSOC) ?: null;
                    $lang = (string) ($cur['language'] ?? 'en');
                    $newNum = pti_alloc_voucher($pdo, (int) date('Y'));
                    $pdo->prepare("UPDATE vouchers SET status='reissued' WHERE sale_id=? AND status='issued'")->execute([$id]);
                    $pdo->prepare("UPDATE sales SET voucher_number=? WHERE id=?")->execute([$newNum, $id]);
                    $pdo->prepare("INSERT INTO vouchers (sale_id,language,status,reissue_of,generated_at) VALUES (?,?, 'issued', ?, NOW())")
                        ->execute([$id, $lang, $cur['id'] ?? null]);
                    $pdo->commit();
                } catch (Throwable $e) { $pdo->rollBack(); throw $e; }
                Audit::log('voucher.reissue', 'sale', $id, [
                    'voucher'     => ['from' => $oldNum, 'to' => $newNum],
                    'reissue_of'  => $cur['id'] ?? null,
                    'approved_by' => $approver['email'] ?? null,
                ], $reason !== '' ? $reason : null);
                redirect('/sales.php?id=' . $id . '&ok=reissue');
            }
        }
    }

    if ($do === 'edit') {
        if ($sale['status'] !== 'paid') {
            $err = 'Upravit lze jen zaplacený prodej.';
        } else {
            $cname  = trim((string) ($_POST['cust_name'] ?? ''));
            $cemail = trim((string) ($_POST['cust_email'] ?? ''));
            $cphone = trim((string) ($_POST['cust_phone'] ?? ''));
            $allowedLang = ['cs', 'en', 'de'];
            $vl  = in_array(($_POST['vlang'] ?? ''), $allowedLang, true) ? (string) $_POST['vlang'] : '';
            $vl2 = in_array(($_POST['vlang2'] ?? ''), $allowedLang, true) ? (string) $_POST['vlang2'] : null;
            $idates = (array) ($_POST['item_date'] ?? []);
            $itimes = (array) ($_POST['item_time'] ?? []);

            $cust = ((int) ($sale['customer_id'] ?? 0) > 0)
                ? (Database::all("SELECT name,email,phone,language FROM customers WHERE id=?", [(int) $sale['customer_id']])[0] ?? null) : null;
            $vrow   = Database::all("SELECT * FROM vouchers WHERE sale_id=? ORDER BY id DESC LIMIT 1", [$id])[0] ?? null;
            $sitems = Database::all("SELECT id, ticket_date, ticket_time FROM sale_items WHERE sale_id=? ORDER BY id", [$id]);
            if ($vl === '') { $vl = (string) ($vrow['language'] ?? 'en'); }

            $changes = [];
            $pdo = Database::pdo();
            $pdo->beginTransaction();
            try {
                if ((int) ($sale['customer_id'] ?? 0) > 0) {
                    $pdo->prepare("UPDATE customers SET name=?, email=?, phone=? WHERE id=?")
                        ->execute([$cname ?: null, $cemail ?: null, $cphone ?: null, (int) $sale['customer_id']]);
                } elseif ($cname !== '' || $cemail !== '' || $cphone !== '') {
                    $pdo->prepare("INSERT INTO customers (name,email,phone,language) VALUES (?,?,?,?)")
                        ->execute([$cname ?: null, $cemail ?: null, $cphone ?: null, $vl]);
                    $pdo->prepare("UPDATE sales SET customer_id=? WHERE id=?")->execute([(int) $pdo->lastInsertId(), $id]);
                }
                if ((string) ($cust['name'] ?? '')  !== $cname)  { $changes['name']  = ['from' => $cust['name'] ?? null, 'to' => $cname]; }
                if ((string) ($cust['email'] ?? '') !== $cemail) { $changes['email'] = ['from' => $cust['email'] ?? null, 'to' => $cemail]; }
                if ((string) ($cust['phone'] ?? '') !== $cphone) { $changes['phone'] = ['from' => $cust['phone'] ?? null, 'to' => $cphone]; }

                if ($vrow) {
                    $oldL = (string) ($vrow['language'] ?? 'en');
                    $oldL2 = $vrow['language_secondary'] ?? null;
                    $pdo->prepare("UPDATE vouchers SET language=?, language_secondary=? WHERE id=?")
                        ->execute([$vl, $vl2, (int) $vrow['id']]);
                    if ($oldL !== $vl)   { $changes['language'] = ['from' => $oldL, 'to' => $vl]; }
                    if ($oldL2 !== $vl2) { $changes['language_secondary'] = ['from' => $oldL2, 'to' => $vl2]; }
                }

                foreach ($sitems as $it) {
                    if (empty($it['ticket_date'])) { continue; }
                    $iid = (int) $it['id'];
                    if (!array_key_exists($iid, $idates)) { continue; }
                    $nd = trim((string) ($idates[$iid] ?? ''));
                    $nt = trim((string) ($itimes[$iid] ?? ''));
                    $pdo->prepare("UPDATE sale_items SET ticket_date=COALESCE(NULLIF(?,''), ticket_date), ticket_time=NULLIF(?,'') WHERE id=? AND sale_id=?")
                        ->execute([$nd, $nt, $iid, $id]);
                    $oldD = (string) $it['ticket_date']; $oldT = substr((string) ($it['ticket_time'] ?? ''), 0, 5);
                    if (($nd !== '' && $nd !== $oldD) || $nt !== $oldT) {
                        $changes['item#' . $iid] = ['from' => trim($oldD . ' ' . $oldT), 'to' => trim(($nd ?: $oldD) . ' ' . $nt)];
                    }
                }
                $pdo->commit();
            } catch (Throwable $e) { $pdo->rollBack(); throw $e; }
            Audit::log('voucher.edit', 'sale', $id, $changes ?: ['note' => 'beze změny']);
            redirect('/sales.php?id=' . $id . '&ok=edit');
        }
    }

    if ($err !== '') { $flash = '<div class="inline-note err">' . e($err) . '</div>'; }
}
if (isset($_GET['ok'])) {
    $msg = [
        'cancel' => 'Prodej stornován, voucher zneplatněn.',
        'refund' => 'Refundace zaznamenána.',
        'reissue' => 'Vystaven nový voucher; staré číslo zneplatněno.',
        'edit' => 'Údaje voucheru upraveny.',
    ][$_GET['ok']] ?? 'Hotovo.';
    $flash = '<div class="inline-note ok">' . e($msg) . '</div>';
}

/* -------------------------------------------------------------- DETAIL */
if ($id) {
    $sale = Database::all(
        "SELECT s.*, c.name AS cname, c.email AS cemail, c.phone AS cphone, c.language AS clang
           FROM sales s LEFT JOIN customers c ON c.id=s.customer_id
         WHERE s.id=? AND s.tenant_id=?", [$id, $tid]
    )[0] ?? null;
    if (!$sale) { redirect('/sales.php'); }
    $items   = Database::all("SELECT * FROM sale_items WHERE sale_id=? ORDER BY id", [$id]);
    $voucher = Database::all("SELECT * FROM vouchers WHERE sale_id=? ORDER BY id DESC LIMIT 1", [$id])[0] ?? null;
    $trail   = Audit::forTarget('sale', $id);
    $pastRealised = (int) Database::scalar(
        "SELECT COUNT(*) FROM sale_items WHERE sale_id=? AND ticket_date IS NOT NULL AND ticket_date < CURDATE()", [$id]
    ) > 0;
    $refunds   = Database::all("SELECT * FROM refunds WHERE sale_id=? ORDER BY id DESC", [$id]);
    $totalC    = (float) $sale['total_czk'];
    $refundedC = (float) ($sale['refunded_czk'] ?? 0);
    $remainC   = round($totalC - $refundedC, 2);

    // items
    $rows = '';
    foreach ($items as $it) {
        $snap  = json_decode((string) $it['snapshot_json'], true) ?: [];
        $name  = $snap['product_name'] ?? ('#' . (int) $it['product_id']);
        $ag    = $snap['agency'] ?? '';
        $chips = '';
        foreach (($snap['chosen'] ?? []) as $c) { $chips .= '<span class="chip-sm">' . e((string) ($c['value'] ?? '')) . '</span>'; }
        $meta = $chips . ' ' . (int) $it['qty'] . '×';
        if (!empty($it['ticket_date'])) {
            $meta .= ' · ' . e((string) $it['ticket_date']) . ($it['ticket_time'] ? ' ' . substr((string) $it['ticket_time'], 0, 5) : '');
        }
        $rows .= '<div class="pay-item"><div><div class="pay-item-n">' . e($name) . '</div>'
            . '<div class="pcard-ag">' . e($ag) . '</div><div class="cart-meta">' . $meta . '</div></div>'
            . '<div class="pay-item-p">' . czk($it['line_total_czk']) . '</div></div>';
    }

    // audit trail
    $trailHtml = '';
    foreach ($trail as $t) {
        $who = ($t['actor_type'] === 'admin' ? 'admin' : 'prodejce') . ' #' . (int) $t['actor_id'];
        $trailHtml .= '<div class="ps-audit"><span class="a-act">' . e($t['action']) . '</span>'
            . '<span class="a-meta">' . e((string) $t['created_at']) . ' · ' . e($who)
            . ($t['reason'] ? ' · „' . e((string) $t['reason']) . '"' : '') . '</span></div>';
    }
    if ($trailHtml === '') { $trailHtml = '<div class="muted">Zatím žádné záznamy.</div>'; }

    // action panels
    $vstatus = $voucher['status'] ?? 'issued';
    $action  = '';
    // Storno — only on a not-yet-refunded paid sale
    if ($sale['status'] === 'paid' && $refundedC <= 0.001) {
        $pinField = $pastRealised
            ? '<label class="ps-lbl">Admin PIN (termín už proběhl – nutné schválení)</label>'
              . '<input class="ps-in" type="password" name="admin_pin" inputmode="numeric" autocomplete="off">'
            : '';
        $hint = $pastRealised
            ? '<div class="muted ps-hint">Termín tohoto prodeje už proběhl → storno schvaluje admin PINem (§3.4).</div>'
            : '<div class="muted ps-hint">Storno před realizací – stačí tvůj PIN. Voucher se zneplatní.</div>';
        $action .= '<div class="panel mt-22"><h3>Storno prodeje</h3>' . $hint
            . '<form method="post" action="/sales.php?id=' . $id . '">' . Csrf::field()
            . '<input type="hidden" name="sale_id" value="' . $id . '"><input type="hidden" name="do" value="cancel">'
            . '<label class="ps-lbl">Důvod storna (povinné)</label>'
            . '<textarea class="ps-in" name="reason" rows="2" required></textarea>'
            . $pinField
            . '<div class="savebar no-print mt-12"><button class="btn-danger" type="submit">Stornovat prodej</button></div>'
            . '</form></div>';
    }
    // Refundace — on a paid sale with refundable remainder
    if ($sale['status'] === 'paid' && $remainC > 0.001) {
        $action .= '<div class="panel mt-22"><h3>Refundace</h3>'
            . '<div class="muted ps-hint">Refundovatelný zbytek: <b>' . czk($remainC) . '</b>'
            . ($refundedC > 0.001 ? ' (již refundováno ' . czk($refundedC) . ')' : '')
            . '. Do 1 500 Kč stačí tvůj PIN; nad 1 500 Kč vyplň admin PIN. Provize se krátí poměrně.</div>'
            . '<form method="post" action="/sales.php?id=' . $id . '">' . Csrf::field()
            . '<input type="hidden" name="sale_id" value="' . $id . '"><input type="hidden" name="do" value="refund">'
            . '<label class="ps-lbl">Částka k refundaci (Kč)</label>'
            . '<input class="ps-in" type="text" name="amount" inputmode="decimal" value="' . rtrim(rtrim(number_format($remainC, 2, '.', ''), '0'), '.') . '">'
            . '<label class="ps-lbl">Důvod refundace (povinné)</label>'
            . '<textarea class="ps-in" name="reason" rows="2" required></textarea>'
            . '<label class="ps-lbl">Admin PIN (jen pokud refunduješ víc než 1 500 Kč)</label>'
            . '<input class="ps-in" type="password" name="admin_pin" inputmode="numeric" autocomplete="off">'
            . '<div class="savebar no-print mt-12"><button class="btn-danger" type="submit">Refundovat</button></div>'
            . '</form></div>';
    }
    // Reissue — fresh voucher number on a paid sale with an active voucher (admin PIN)
    if ($sale['status'] === 'paid' && !empty($sale['voucher_number']) && $vstatus === 'issued') {
        $action .= '<div class="panel mt-22"><h3>Vystavit nový voucher (reissue)</h3>'
            . '<div class="muted ps-hint">Vystaví nový voucher s novým číslem a původní číslo zneplatní (ztráta nebo únik dokladu). Obsah a cena prodeje se nemění. Schvaluje admin PINem.</div>'
            . '<form method="post" action="/sales.php?id=' . $id . '">' . Csrf::field()
            . '<input type="hidden" name="sale_id" value="' . $id . '"><input type="hidden" name="do" value="reissue">'
            . '<label class="ps-lbl">Důvod (volitelné)</label>'
            . '<textarea class="ps-in" name="reason" rows="2"></textarea>'
            . '<label class="ps-lbl">Admin PIN (nutné schválení)</label>'
            . '<input class="ps-in" type="password" name="admin_pin" inputmode="numeric" autocomplete="off">'
            . '<div class="savebar no-print mt-12"><button class="btn-p" type="submit">Vystavit nový voucher</button></div>'
            . '</form></div>';
    }
    // Edit voucher metadata — customer + language + ticket date/time (no money change; audited)
    if ($sale['status'] === 'paid') {
        $langOpt = function (string $cur): string {
            $names = ['cs' => 'Čeština', 'en' => 'Angličtina', 'de' => 'Němčina'];
            $o = '';
            foreach ($names as $k => $v) { $o .= '<option value="' . $k . '"' . ($cur === $k ? ' selected' : '') . '>' . $v . '</option>'; }
            return $o;
        };
        $curL  = (string) ($voucher['language'] ?? 'en');
        $curL2 = (string) ($voucher['language_secondary'] ?? '');
        $dateRows = '';
        foreach ($items as $it) {
            if (empty($it['ticket_date'])) { continue; }
            $iid  = (int) $it['id'];
            $snap = json_decode((string) $it['snapshot_json'], true) ?: [];
            $nm   = $snap['product_name'] ?? ('#' . (int) $it['product_id']);
            $tt   = $it['ticket_time'] ? substr((string) $it['ticket_time'], 0, 5) : '';
            $dateRows .= '<label class="ps-lbl">' . e($nm) . ' — termín / čas</label>'
                . '<input class="ps-in" type="date" name="item_date[' . $iid . ']" value="' . e((string) $it['ticket_date']) . '">'
                . '<input class="ps-in" type="time" name="item_time[' . $iid . ']" value="' . e($tt) . '">';
        }
        $action .= '<div class="panel mt-22"><h3>Upravit údaje voucheru</h3>'
            . '<div class="muted ps-hint">Oprava jména/kontaktu, jazyka voucheru a termínu u date-required položek. Cena, marže ani položky se nemění. Změny jdou do historie; pak stačí reprint.</div>'
            . '<form method="post" action="/sales.php?id=' . $id . '">' . Csrf::field()
            . '<input type="hidden" name="sale_id" value="' . $id . '"><input type="hidden" name="do" value="edit">'
            . '<label class="ps-lbl">Jméno zákazníka</label><input class="ps-in" type="text" name="cust_name" value="' . e((string) ($sale['cname'] ?? '')) . '">'
            . '<label class="ps-lbl">E-mail</label><input class="ps-in" type="text" name="cust_email" value="' . e((string) ($sale['cemail'] ?? '')) . '">'
            . '<label class="ps-lbl">Telefon</label><input class="ps-in" type="text" name="cust_phone" value="' . e((string) ($sale['cphone'] ?? '')) . '">'
            . '<label class="ps-lbl">Jazyk voucheru</label><select class="ps-in" name="vlang">' . $langOpt($curL) . '</select>'
            . '<label class="ps-lbl">Druhý jazyk (volitelné)</label><select class="ps-in" name="vlang2"><option value="">—</option>' . $langOpt($curL2) . '</select>'
            . $dateRows
            . '<div class="savebar no-print mt-12"><button class="btn-p" type="submit">Uložit změny</button></div>'
            . '</form></div>';
    }
    if ($action === '') {
        $note = $sale['status'] === 'refunded' ? 'Prodej je plně refundován.'
            : ($sale['status'] === 'cancelled' ? 'Prodej je stornován.' : 'Žádné dostupné operace.');
        $action = '<div class="panel mt-22"><h3>Akce</h3><div class="muted">' . e($note)
            . ' Editace voucheru přijde v dalším slicu.</div></div>';
    }

    // refunds history
    $refundHtml = '';
    foreach ($refunds as $r) {
        $who = ($r['actor_type'] === 'admin' ? 'admin' : 'prodejce') . ' #' . (int) $r['actor_id'];
        $refundHtml .= '<div class="ps-audit"><span class="a-act">' . czk($r['amount_czk'])
            . ' · ' . ($r['kind'] === 'full' ? 'plná' : 'částečná') . '</span>'
            . '<span class="a-meta">' . e(substr((string) $r['created_at'], 0, 16)) . ' · ' . e($who)
            . ' · provize −' . czk($r['commission_reversed_czk'])
            . ($r['reason'] ? ' · „' . e((string) $r['reason']) . '"' : '') . '</span></div>';
    }

    $vbtn = ($vstatus === 'voided')
        ? '<span class="muted">Voucher zneplatněn</span>'
        : '<a class="btn-p" href="/voucher.php?sale=' . $id . '" target="_blank" rel="noopener">Otevřít voucher (PDF)</a>';

    $body = '<div class="shome-crumb"><a class="btn-g" href="/sales.php">← Prodeje</a>'
        . '<span>Voucher ' . e((string) ($sale['voucher_number'] ?? '—')) . '</span></div>'
        . $flash
        . '<div class="panel"><div class="ps-head">'
        . '<div><h1 class="ps-h1">' . e((string) ($sale['voucher_number'] ?? ('Prodej #' . $id))) . '</h1>'
        . '<div class="muted">' . e((string) ($sale['cname'] ?? 'bez jména')) . ' · ' . e((string) $sale['created_at']) . '</div></div>'
        . st_badge((string) $sale['status'], $STBADGE) . '</div>'
        . ($sale['status'] === 'cancelled' && $sale['cancel_reason'] ? '<div class="inline-note">Důvod storna: ' . e((string) $sale['cancel_reason']) . '</div>' : '')
        . $rows
        . '<div class="pay-sum mt-12"><span class="pay-sum-l">Celkem</span><span class="pay-sum-czk">' . czk($sale['total_czk']) . '</span></div>'
        . ($sale['total_eur'] !== null ? '<div class="pay-sum-eur">' . eur($sale['total_eur']) . '</div>' : '')
        . '<div class="pay-paid"><span>Platba</span><span>' . e($PM[$sale['payment_method']] ?? (string) $sale['payment_method']) . '</span></div>'
        . ($refundedC > 0.001 ? '<div class="pay-balance"><span>Refundováno</span><span>−' . czk($refundedC) . '</span></div>' : '')
        . '<div class="savebar no-print mt-12">' . $vbtn . '</div>'
        . '</div>'
        . $action
        . ($refundHtml !== '' ? '<div class="panel mt-22"><h3>Refundace</h3>' . $refundHtml . '</div>' : '')
        . '<div class="panel mt-22"><h3>Historie / audit</h3>' . $trailHtml . '</div>';

    View::shell('Správa prodeje', $a, $body,
        ['tenant' => $tenant['name'] ?? null, 'subtitle' => 'správa prodeje', 'logout' => '/?action=logout']);
}

/* ---------------------------------------------------------------- LIST */
$q = trim((string) ($_GET['q'] ?? ''));
$params = [$tid];
$where  = "s.tenant_id=? AND s.status<>'draft'";
if ($q !== '') {
    $where   .= " AND (s.voucher_number LIKE ? OR c.name LIKE ?)";
    $params[] = '%' . $q . '%';
    $params[] = '%' . $q . '%';
}
$sales = Database::all(
    "SELECT s.*, c.name AS cname FROM sales s LEFT JOIN customers c ON c.id=s.customer_id
     WHERE $where ORDER BY s.id DESC LIMIT 60", $params
);

$list = '';
foreach ($sales as $s) {
    $list .= '<a class="ps-row" href="/sales.php?id=' . (int) $s['id'] . '">'
        . '<span class="ps-row-v">' . e((string) ($s['voucher_number'] ?? ('#' . (int) $s['id']))) . '</span>'
        . '<span class="ps-row-c">' . e((string) ($s['cname'] ?? '—')) . '</span>'
        . '<span class="ps-row-d muted">' . e(substr((string) $s['created_at'], 0, 16)) . '</span>'
        . '<span class="ps-row-pm">' . e($PM[$s['payment_method']] ?? '—') . '</span>'
        . '<span class="ps-row-t">' . czk($s['total_czk']) . '</span>'
        . st_badge((string) $s['status'], $STBADGE) . '</a>';
}
if ($list === '') { $list = '<div class="muted">Žádné prodeje.</div>'; }

$listHdr = $sales
    ? '<div class="ps-head-row"><span class="ps-row-v">Voucher</span><span class="ps-row-c">Zákazník</span>'
      . '<span class="ps-row-d">Vytvořeno</span><span class="ps-row-pm">Platba</span><span class="ps-row-t">Celkem</span><span>Stav</span></div>'
    : '';

$body = '<div class="shome-crumb"><a class="btn-g" href="/">← Dashboard</a><span>Prodeje</span></div>'
    . $flash
    . '<form method="get" action="/sales.php" class="ps-search">'
    . '<input class="ps-in" type="text" name="q" value="' . e($q) . '" placeholder="Hledej číslo voucheru nebo jméno…">'
    . '<button class="btn-s" type="submit">Hledat</button>'
    . ($q !== '' ? '<a class="btn-g" href="/sales.php">Zrušit</a>' : '')
    . '</form>'
    . '<div class="panel">' . $listHdr . $list . '</div>';

View::shell('Prodeje', $a, $body,
    ['tenant' => $tenant['name'] ?? null, 'subtitle' => 'prodejní místo', 'logout' => '/?action=logout']);
