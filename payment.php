<?php
declare(strict_types=1);

/** Finalize sale (3c): recap → optional customer → pickup (if any) →
 *  payment form (cash/card, recorded only) → confirm. On confirm, in ONE
 *  transaction: sales(paid) + sale_items(snapshot) + sequential voucher number
 *  (PTI-YYYY-NNNNNN, global, no gaps) + voucher row. Seller sees customer
 *  prices only — never margin/cost/bonus. */

define('PTI_BASE', __DIR__ . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
if (!Auth::isStation() || Auth::expired()) { redirect("/"); }
$a = Auth::actor();
$tenant = Auth::tenantById((int) $a['tenant_id']);

$cart = $_SESSION['cart'] ?? [];
if (!$cart) { redirect('/'); }

function czk($n): string { return number_format((float) $n, 0, ',', "\u{00A0}") . "\u{00A0}Kč"; }
function eur($n): string { return $n === null ? '' : number_format((float) $n, 0, ',', "\u{00A0}") . "\u{00A0}€"; }

$LANGS = ['en' => 'Angličtina', 'cs' => 'Čeština', 'de' => 'Němčina'];

// pti_alloc_voucher() now lives in app/helpers.php (shared with sales.php reissue).

$sumC = 0.0; $sumE = 0.0; $anyE = false; $needPickup = false;
$depPaidC = 0.0; $depPaidE = 0.0; $depositAvailable = false;
foreach ($cart as $it) {
    $q = $it['q'];
    $sumC += (float) $q['customer_czk'];
    if ($q['customer_eur'] !== null) { $sumE += (float) $q['customer_eur']; $anyE = true; }
    if (!empty($it['pickup_available']) || !empty($it['pickup_required'])) { $needPickup = true; }
    // deposit per item: agency-deposit items pay our commission (fixed override × qty, else margin); others pay full
    if (!empty($it['agency_deposit'])) {
        $depositAvailable = true;
        $dc = (isset($it['deposit_fixed_czk']) && $it['deposit_fixed_czk'] !== null)
            ? (float) $it['deposit_fixed_czk'] * (int) $it['qty'] : (float) ($q['margin_czk'] ?? 0);
        $de = (isset($it['deposit_fixed_eur']) && $it['deposit_fixed_eur'] !== null)
            ? (float) $it['deposit_fixed_eur'] * (int) $it['qty'] : ($q['margin_eur'] !== null ? (float) $q['margin_eur'] : null);
    } else {
        $dc = (float) $q['customer_czk'];
        $de = $q['customer_eur'] !== null ? (float) $q['customer_eur'] : null;
    }
    $depPaidC += $dc;
    if ($de !== null) { $depPaidE += $de; }
}

$err = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['do'] ?? '') === 'confirm') {
    $pm   = (string) ($_POST['payment_method'] ?? '');
    $lang = array_key_exists($_POST['voucher_lang'] ?? '', $LANGS) ? $_POST['voucher_lang'] : 'en';
    $cName  = trim((string) ($_POST['customer_name'] ?? ''));
    $cEmail = trim((string) ($_POST['customer_email'] ?? ''));
    $cPhone = trim((string) ($_POST['customer_phone'] ?? ''));

    if (!in_array($pm, ['cash', 'card'], true)) {
        $err = 'Vyber formu platby (hotovost / karta).';
    } else {
        foreach ($cart as $it) {
            if (!empty($it['is_pickup']) && empty($it['pickup_addr'])) {
                $err = 'U svozu chybí adresa vyzvednutí – zadej ji na prodejní stránce.'; break;
            }
        }
    }
    // Prodejce se identifikuje PINem u platby (rotující personál na sdílených stanicích).
    // Bez platného PINu se voucher nevystaví — zároveň bezpečnostní pojistka.
    $sellerRow = null;
    if (!$err) {
        $sellerRow = Auth::sellerCheckPin((int) $a['tenant_id'], (string) ($_POST['seller_pin'] ?? ''));
        if (!$sellerRow) {
            $rem = Auth::lockRemaining('pin', 'tenant:' . (int) $a['tenant_id']);
            $err = $rem > 0
                ? 'Příliš mnoho pokusů. Zkus to za ' . (int) ceil($rem / 60) . ' min.'
                : 'Zadej platný PIN prodejce — bez něj nelze vystavit voucher.';
        }
    }

    if (!$err) {
        $pdo = Database::pdo();
        $pdo->beginTransaction();
        try {
            $custId = null;
            if ($cName !== '' || $cEmail !== '' || $cPhone !== '') {
                $pdo->prepare("INSERT INTO customers (name,email,phone,language) VALUES (?,?,?,?)")
                    ->execute([$cName ?: null, $cEmail ?: null, $cPhone ?: null, $lang]);
                $custId = (int) $pdo->lastInsertId();
            }
            $payAmount = ($_POST['payment_amount'] ?? 'full');
            $isDeposit = ($depositAvailable && $payAmount === 'deposit') ? 1 : 0;
            if ($isDeposit) {
                $depAmt = (float) str_replace(',', '.', (string) ($_POST['deposit_amount'] ?? ''));
                if ($depAmt <= 0) { $depAmt = $depPaidC; }   // blank/invalid → suggested deposit
                if ($depAmt > $sumC) { $depAmt = $sumC; }     // never more than the total
                $paidC = $depAmt;
                $paidE = $anyE ? ($sumC > 0 ? round($sumE * ($depAmt / $sumC), 2) : $depPaidE) : null;
                $balC = $sumC - $paidC; $balE = $anyE ? ($sumE - $paidE) : null;
            } else {
                $paidC = $sumC; $paidE = $anyE ? $sumE : null; $balC = 0.0; $balE = $anyE ? 0.0 : null;
            }
            $bookingPin = str_pad((string) random_int(0, 9999), 4, '0', STR_PAD_LEFT);
            $pdo->prepare("INSERT INTO sales (tenant_id,station_id,seller_id,customer_id,status,total_czk,total_eur,
                           payment_method,is_deposit,paid_czk,paid_eur,balance_czk,balance_eur,pin,paid_at)
                           VALUES (?,?,?,?,'paid',?,?,?,?,?,?,?,?,?,NOW())")
                ->execute([(int) $a['tenant_id'], $a['station_id'] ?? null, (int) $sellerRow['id'], $custId, $sumC, ($anyE ? $sumE : null),
                           $pm, $isDeposit, $paidC, $paidE, $balC, $balE, $bookingPin]);
            $saleId = (int) $pdo->lastInsertId();

            $insItem = $pdo->prepare("INSERT INTO sale_items
                (sale_id,product_id,pricing_version_id,cell_key,snapshot_json,qty,unit_price_czk,unit_price_eur,
                 discount_pct,line_total_czk,line_total_eur,commission_pct,commission_czk,
                 seller_bonus_pct,seller_bonus_czk,agency_cost_czk,agency_cost_eur,ticket_date,ticket_time)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            $insPickup = $pdo->prepare("INSERT INTO pickups (sale_item_id,address,pickup_time,status) VALUES (?,?,?,'pending')");
            foreach ($cart as $it) {
                $q = $it['q'];
                $insItem->execute([
                    $saleId, $it['product_id'] ?: null, $it['version_id'] ?: null, $it['cell_key'] ?? null,
                    json_encode($it, JSON_UNESCAPED_UNICODE),
                    (int) $it['qty'], $it['retail_czk'], $it['retail_eur'],
                    $it['discount_pct'], $q['customer_czk'], $q['customer_eur'],
                    $it['commission_pct'] ?? null, $q['margin_czk'] ?? null,
                    $it['bonus_pct'] ?? null, $q['bonus_czk'] ?? null, $q['agency_czk'] ?? null, $q['agency_eur'] ?? null,
                    $it['ticket_date'] ?: null, $it['ticket_time'] ?: null,
                ]);
                $itemId = (int) $pdo->lastInsertId();
                if (!empty($it['is_pickup']) || !empty($it['pickup_addr']) || !empty($it['pickup_time'])) {
                    $insPickup->execute([$itemId, ($it['pickup_addr'] ?? null) ?: null, ($it['pickup_time'] ?? null) ?: null]);
                }
            }

            $vnum = pti_alloc_voucher($pdo, (int) date('Y'));
            $pdo->prepare("UPDATE sales SET voucher_number=? WHERE id=?")->execute([$vnum, $saleId]);
            $pdo->prepare("INSERT INTO vouchers (sale_id,language,status,generated_at) VALUES (?,?, 'issued', NOW())")
                ->execute([$saleId, $lang]);

            $pdo->commit();
        } catch (Throwable $ex) { $pdo->rollBack(); throw $ex; }

        unset($_SESSION['cart']);
        redirect('/success.php?sale=' . $saleId);
    }
}

$rows = '';
foreach ($cart as $it) {
    $chips = '';
    foreach ($it['chosen'] as $c) { $chips .= '<span class="chip-sm">' . e($c['value']) . '</span>'; }
    $meta = $chips . ' ' . (int) $it['qty'] . '×';
    if (!empty($it['ticket_date'])) { $meta .= ' · ' . e($it['ticket_date']) . (!empty($it['ticket_time']) ? ' ' . e($it['ticket_time']) : ''); }
    $rows .= '<div class="pay-item"><div><div class="pay-item-n">' . e($it['product_name']) . '</div>'
        . '<div class="pcard-ag">' . e($it['agency']) . '</div><div class="cart-meta">' . $meta . '</div></div>'
        . '<div class="pay-item-p">' . czk($it['q']['customer_czk']) . ($it['q']['customer_eur'] !== null ? '<div class="cart-price-eur">' . eur($it['q']['customer_eur']) . '</div>' : '') . '</div></div>';
}

$pickupHtml = '';
if (false) { // pickup se nyní zadává na prodejní stránce (rezervační krok)
    $pf = '';
    foreach ($cart as $it) {
        if (empty($it['pickup_available']) && empty($it['pickup_required'])) { continue; }
        $req = !empty($it['pickup_required']);
        $pf .= '<div class="pay-pickup-row"><div class="pay-pickup-n">' . e($it['product_name'])
            . ($req ? ' <span class="req">povinné</span>' : ' <span class="muted">(nepovinné)</span>') . '</div>'
            . '<div class="grid-2">'
            . '<div class="field"><label>Adresa svozu / hotel</label><input name="pickup_addr[' . e($it['lid']) . ']"></div>'
            . '<div class="field"><label>Čas svozu</label><input name="pickup_time[' . e($it['lid']) . ']" placeholder="např. 8:15"></div>'
            . '</div></div>';
    }
    $pickupHtml = '<div class="panel mt-22"><h3>Svoz (pickup)</h3>' . $pf . '</div>';
}

$langOpts = '';
foreach ($LANGS as $k => $lbl) { $langOpts .= '<option value="' . $k . '"' . ($k === 'en' ? ' selected' : '') . '>' . e($lbl) . '</option>'; }

$errHtml = $err ? '<div class="alert alert-err">' . e($err) . '</div>' : '';
$eurLine = $anyE ? '<div class="pay-sum-eur">' . eur($sumE) . '</div>' : '';

$depBalC = $sumC - $depPaidC;
$payChoice = '';
if ($depositAvailable) {
    $payChoice = '<div class="pay-amount" data-pay-amount'
        . ' data-full-paid="' . e(czk($sumC)) . '" data-dep-paid="' . e(czk($depPaidC)) . '"'
        . ' data-full-bal="' . e(czk(0)) . '" data-dep-bal="' . e(czk($depBalC)) . '">'
        . '<div class="pay-amount-l">Způsob úhrady</div>'
        . '<label class="pay-amt-opt"><input type="radio" name="payment_amount" value="full" checked><span>Plná platba</span></label>'
        . '<label class="pay-amt-opt"><input type="radio" name="payment_amount" value="deposit"><span>Záloha (rezervační deposit) — doplatek u agentury</span></label>'
        . '<div class="field"><label>Výše zálohy (Kč) — lze upravit</label>'
        . '<input name="deposit_amount" inputmode="decimal" value="' . e(rtrim(rtrim(number_format($depPaidC, 2, '.', ''), '0'), '.')) . '"></div>'
        . '</div>';
}

$body = '<a class="pd-back" href="/cart.php">← Zpět do košíku</a>'
    . '<div class="bld-head"><h1>Dokončení prodeje</h1></div>'
    . $errHtml
    . '<form method="post" class="pay-grid"><div>' . Csrf::field() . '<input type="hidden" name="do" value="confirm">'
    . '<div class="panel"><h3>Položky</h3>' . $rows . '</div>'
    . '<div class="panel mt-22"><h3>Zákazník <span class="h3-opt">— nepovinné</span></h3>'
    . '<div class="grid-2">'
    . '<div class="field"><label>Jméno</label><input name="customer_name"></div>'
    . '<div class="field"><label>E-mail</label><input name="customer_email" type="email"></div>'
    . '<div class="field"><label>Telefon</label><input name="customer_phone"></div>'
    . '<div class="field"><label>Jazyk voucheru</label><select name="voucher_lang">' . $langOpts . '</select></div>'
    . '</div></div>'
    . $pickupHtml
    . '<div class="panel mt-22"><h3>Forma platby</h3>'
    . '<div class="pay-methods">'
    . '<label class="pay-method"><input type="radio" name="payment_method" value="cash"><span>Hotovost</span></label>'
    . '<label class="pay-method"><input type="radio" name="payment_method" value="card"><span>Karta</span></label>'
    . '</div><div class="inline-note">Platba probíhá na pokladně / terminálu PTI; tady se jen zaznamená forma.</div></div>'
    . '</div>'
    . '<aside class="pay-side"><h3>Souhrn</h3>'
    . '<div class="pay-sum"><span class="pay-sum-l">Celkem</span><span class="pay-sum-czk">' . czk($sumC) . '</span></div>' . $eurLine
    . $payChoice
    . '<div class="pay-paid"><span>Zaplaceno</span><span data-paid>' . czk($sumC) . '</span></div>'
    . '<div class="pay-balance" data-balance-wrap><span>Doplatek</span><span data-balance>' . czk(0) . '</span></div>'
    . '<div class="pay-pin"><label class="pay-pin-l">PIN prodejce</label>'
    . '<input type="password" name="seller_pin" inputmode="numeric" autocomplete="off" maxlength="8" placeholder="••••" class="pay-pin-input" required>'
    . '<span class="pay-pin-note">Tvůj PIN podepíše prodej a vystaví voucher.</span></div>'
    . '<button type="submit" class="btn-p pay-confirm">Dokončit a vystavit voucher</button>'
    . '</aside></form>';

View::shell('Dokončení prodeje', $a, $body,
    ['tenant' => $tenant['name'] ?? null, 'subtitle' => 'prodejní místo', 'logout' => '/?action=logout', 'js' => true]);
