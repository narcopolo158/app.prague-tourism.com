<?php
declare(strict_types=1);

/** Admin → Produkty: list + create + edit + (de)activate.
 *  Covers all operational fields from the 001 products schema + M2M categories.
 *  Cenové dimenze se konfigurují později, se schématem cen (migrace 003). */

define('PTI_BASE', dirname(__DIR__) . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
$a = Auth::requireAdmin('/admin/');

// enum label maps (CS)
const SCHEDULE = ['continuous'=>'průběžně','fixed_daily'=>'pevný čas denně','multiple_daily'=>'více časů denně',
    'weekly_pattern'=>'týdenní vzor','seasonal'=>'sezónní','specific_dates'=>'konkrétní termíny','on_demand'=>'na vyžádání'];
const REDEEM = ['direct_entry'=>'přímý vstup','box_office_exchange'=>'výměna v pokladně',
    'bus_activation'=>'aktivace v busu','agency_call'=>'volat agenturu'];
const TICKET = ['open'=>'otevřený (bez data)','date_required'=>'s konkrétním datem'];
const PCONF  = ['fixed'=>'pevné','tbc_agency'=>'potvrdí agentura'];

function audit_prod(array $a, string $action, int $id): void {
    Database::pdo()->prepare("INSERT INTO audit_log (actor_type,actor_id,action,target_type,target_id,ip_address) VALUES ('admin',?,?,'product',?,?)")
        ->execute([(int) $a['id'], $action, (string) $id, client_ip()]);
}

$msg = ''; $err = '';
$editId = isset($_GET['edit']) ? (int) $_GET['edit'] : 0;
if (isset($_GET['saved'])) { $msg = 'Uloženo.'; }
if (isset($_GET['dup']))   { $msg = 'Produkt zduplikován jako neaktivní kopie — uprav a aktivuj.'; }
if (isset($_GET['deleted'])) { $msg = 'Produkt smazán.'; }
$deleteId = (int) ($_GET['delete'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $do = $_POST['do'] ?? '';
    if ($do === 'save') {
        $id      = (int) ($_POST['id'] ?? 0);
        $cs      = trim($_POST['name_cs'] ?? '');
        $en      = trim($_POST['name_en'] ?? '');
        $de      = trim($_POST['name_de'] ?? '');
        $dcs     = trim($_POST['description_cs'] ?? '');
        $den     = trim($_POST['description_en'] ?? '');
        $dde     = trim($_POST['description_de'] ?? '');
        $langs   = trim($_POST['languages'] ?? '');
        $LANG_CODES = ['en','de','fr','es','it','ru'];
        $langOptsIn = (array) ($_POST['language_options'] ?? []);
        $langOptsArr = array_values(array_filter($LANG_CODES, fn($c) => in_array($c, $langOptsIn, true)));
        $langOptsJson = $langOptsArr ? json_encode($langOptsArr) : null;
        $agency  = (int) ($_POST['agency_id'] ?? 0);
        $dur     = ($_POST['duration_minutes'] ?? '') === '' ? null : (int) $_POST['duration_minutes'];
        $sched   = array_key_exists($_POST['schedule_type'] ?? '', SCHEDULE) ? $_POST['schedule_type'] : 'on_demand';
        $redeem  = array_key_exists($_POST['voucher_redemption_type'] ?? '', REDEEM) ? $_POST['voucher_redemption_type'] : 'direct_entry';
        $ticket  = array_key_exists($_POST['ticket_type'] ?? '', TICKET) ? $_POST['ticket_type'] : 'date_required';
        $pAvail  = isset($_POST['pickup_available']) ? 1 : 0;
        $pReq    = isset($_POST['pickup_required']) ? 1 : 0;
        $pFree   = isset($_POST['pickup_free']) ? 1 : 0;
        $pWin    = ($_POST['pickup_window_minutes'] ?? '') === '' ? null : (int) $_POST['pickup_window_minutes'];
        $pConf   = array_key_exists($_POST['pickup_confirmation'] ?? '', PCONF) ? $_POST['pickup_confirmation'] : null;
        $cats    = array_map('intval', (array) ($_POST['categories'] ?? []));
        $comm    = ($_POST['commission_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['commission_pct']);
        $bonus   = ($_POST['seller_bonus_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['seller_bonus_pct']);
        $oinstr  = trim($_POST['order_instructions'] ?? '');
        $burl    = trim($_POST['booking_url'] ?? '');
        $hasCont = isset($_POST['has_contingent']) ? 1 : 0;
        $depFixCzk = trim((string)($_POST['deposit_fixed_czk'] ?? '')); $depFixCzk = $depFixCzk === '' ? null : (float) str_replace(',', '.', $depFixCzk);
        $depFixEur = trim((string)($_POST['deposit_fixed_eur'] ?? '')); $depFixEur = $depFixEur === '' ? null : (float) str_replace(',', '.', $depFixEur);
        $mpAddr = trim((string)($_POST['meeting_point_address'] ?? '')) ?: null;
        $mapUrl = trim((string)($_POST['map_url'] ?? '')) ?: null;
        $incl    = trim((string)($_POST['included'] ?? '')) ?: null;
        $excl    = trim((string)($_POST['excluded'] ?? '')) ?: null;
        $bring   = trim((string)($_POST['what_to_bring'] ?? '')) ?: null;
        $impinfo = trim((string)($_POST['important_info'] ?? '')) ?: null;
        $cancel  = trim((string)($_POST['cancellation_policy'] ?? '')) ?: null;
        $mpNote  = trim((string)($_POST['meeting_point_note'] ?? '')) ?: null;
        $mOpts   = trim((string)($_POST['meeting_options'] ?? '')) ?: null;
        $seating = !empty($_POST['seating']) ? 1 : 0;
        $addonsArr = [];
        foreach (preg_split('/\r\n|\r|\n/', (string)($_POST['addons'] ?? '')) as $ln) {
            $ln = trim($ln); if ($ln === '') continue;
            $parts = array_map('trim', explode('|', $ln)); if ($parts[0] === '') continue;
            $addonsArr[] = ['label' => $parts[0], 'czk' => (float) str_replace(',', '.', $parts[1] ?? '0'), 'eur' => (isset($parts[2]) && $parts[2] !== '') ? (float) str_replace(',', '.', $parts[2]) : null];
        }
        $addonsJson = $addonsArr ? json_encode($addonsArr, JSON_UNESCAPED_UNICODE) : null;

        if ($cs === '')                               $err = 'Zadej český název produktu.';
        elseif (!Database::scalar("SELECT COUNT(*) FROM agencies WHERE id=? AND status='active'", [$agency])) $err = 'Vyber platnou agenturu.';

        if (!$err) {
            $pdo = Database::pdo();
            $pdo->beginTransaction();
            try {
                if ($id > 0) {
                    $pdo->prepare("UPDATE products SET agency_id=?,name_cs=?,name_en=?,name_de=?,description_cs=?,description_en=?,description_de=?,languages=?,duration_minutes=?,schedule_type=?,voucher_redemption_type=?,ticket_type=?,pickup_available=?,pickup_required=?,pickup_free=?,pickup_window_minutes=?,pickup_confirmation=?,commission_pct=?,seller_bonus_pct=?,order_instructions=?,booking_url=?,has_contingent=?,deposit_fixed_czk=?,deposit_fixed_eur=?,meeting_point_address=?,map_url=?,included=?,excluded=?,what_to_bring=?,important_info=?,cancellation_policy=?,meeting_point_note=?,meeting_options=?,seating=?,addons=? WHERE id=?")
                        ->execute([$agency,$cs,$en?:null,$de?:null,$dcs?:null,$den?:null,$dde?:null,$langs?:null,$dur,$sched,$redeem,$ticket,$pAvail,$pReq,$pFree,$pWin,$pConf,$comm,$bonus,$oinstr?:null,$burl?:null,$hasCont,$depFixCzk,$depFixEur,$mpAddr,$mapUrl,$incl,$excl,$bring,$impinfo,$cancel,$mpNote,$mOpts,$seating,$addonsJson,$id]);
                    audit_prod($a, 'product.update', $id); $msg = 'Produkt uložen.';
                } else {
                    $pdo->prepare("INSERT INTO products (agency_id,name_cs,name_en,name_de,description_cs,description_en,description_de,languages,duration_minutes,schedule_type,voucher_redemption_type,ticket_type,pickup_available,pickup_required,pickup_free,pickup_window_minutes,pickup_confirmation,commission_pct,seller_bonus_pct,order_instructions,booking_url,has_contingent,deposit_fixed_czk,deposit_fixed_eur,meeting_point_address,map_url,included,excluded,what_to_bring,important_info,cancellation_policy,meeting_point_note,meeting_options,seating,addons,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'active')")
                        ->execute([$agency,$cs,$en?:null,$de?:null,$dcs?:null,$den?:null,$dde?:null,$langs?:null,$dur,$sched,$redeem,$ticket,$pAvail,$pReq,$pFree,$pWin,$pConf,$comm,$bonus,$oinstr?:null,$burl?:null,$hasCont,$depFixCzk,$depFixEur,$mpAddr,$mapUrl,$incl,$excl,$bring,$impinfo,$cancel,$mpNote,$mOpts,$seating,$addonsJson]);
                    $id = (int) $pdo->lastInsertId(); audit_prod($a, 'product.create', $id); $msg = 'Produkt vytvořen.';
                }
                // objednatelné jazyky výkladu (language_options) — samostatně, ať se nešahá do velkého INSERT/UPDATE
                $pdo->prepare("UPDATE products SET language_options=? WHERE id=?")->execute([$langOptsJson, $id]);
                // sync categories
                $pdo->prepare("DELETE FROM product_categories WHERE product_id=?")->execute([$id]);
                if ($cats) {
                    $ins = $pdo->prepare("INSERT IGNORE INTO product_categories (product_id,category_id) VALUES (?,?)");
                    foreach ($cats as $cid) { if ($cid > 0) $ins->execute([$id, $cid]); }
                }
                $pdo->commit();
            } catch (Throwable $ex) { $pdo->rollBack(); throw $ex; }

            // ---- product image (after the record exists) ----
            $curImg = (string) (Database::scalar("SELECT image_path FROM products WHERE id=?", [$id]) ?? '');
            if (!empty($_POST['remove_image']) && $curImg !== '') {
                delete_product_image($curImg);
                Database::pdo()->prepare("UPDATE products SET image_path=NULL WHERE id=?")->execute([$id]);
                $msg .= ' Obrázek odebrán.';
            } elseif (isset($_FILES['image']) && ($_FILES['image']['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE) {
                $res = save_product_image($_FILES['image'], $id);
                if ($res['ok']) {
                    if ($curImg !== '') { delete_product_image($curImg); }
                    Database::pdo()->prepare("UPDATE products SET image_path=? WHERE id=?")->execute([$res['path'], $id]);
                    $msg .= ' Obrázek nahrán.';
                } elseif ($res['error']) {
                    $err = $res['error'];
                }
            }
            if (!$err) {
                $after = ($_POST['after'] ?? 'stay') === 'close' ? 'close' : 'stay';
                redirect($after === 'close'
                    ? '/admin/products.php?saved=1'
                    : '/admin/products.php?edit=' . $id . '&saved=1#prod-editor');
            }
        } else { $editId = $id; }
    }
    if ($do === 'feature') {
        $id = (int) ($_POST['id'] ?? 0);
        $cur = (int) Database::scalar("SELECT is_featured FROM products WHERE id=?", [$id]);
        $new = $cur ? 0 : 1;
        Database::pdo()->prepare("UPDATE products SET is_featured=? WHERE id=?")->execute([$new, $id]);
        audit_prod($a, 'product.featured.' . $new, $id); $msg = $new ? 'Připnuto do Oblíbených.' : 'Odepnuto z Oblíbených.';
    }
    if ($do === 'duplicate') {
        $sid = (int) ($_POST['id'] ?? 0);
        if ($sid > 0 && Database::scalar("SELECT COUNT(*) FROM products WHERE id=?", [$sid])) {
            $pdo = Database::pdo(); $pdo->beginTransaction();
            try {
                $cols = "agency_id,name_en,name_de,description_cs,description_en,description_de,languages,language_options,duration_minutes,schedule_type,voucher_redemption_type,ticket_type,pickup_available,pickup_required,pickup_free,pickup_window_minutes,pickup_confirmation,commission_pct,seller_bonus_pct,order_instructions,booking_url,has_contingent,deposit_fixed_czk,deposit_fixed_eur,meeting_point_address,map_url,included,excluded,what_to_bring,important_info,cancellation_policy,meeting_point_note,meeting_options,seating,addons";
                $pdo->prepare("INSERT INTO products (name_cs,$cols,status)
                               SELECT CONCAT(name_cs,' (kopie)'),$cols,'inactive' FROM products WHERE id=?")->execute([$sid]);
                $newId = (int) $pdo->lastInsertId();
                $pdo->prepare("INSERT IGNORE INTO product_categories (product_id,category_id)
                               SELECT ?,category_id FROM product_categories WHERE product_id=?")->execute([$newId, $sid]);
                $pdo->commit();
                audit_prod($a, 'product.duplicate', $newId);
                redirect('/admin/products.php?edit=' . $newId . '&dup=1#prod-editor');
            } catch (Throwable $ex) { $pdo->rollBack(); $err = 'Duplikace selhala: ' . $ex->getMessage(); }
        }
    }
    if ($do === 'delete') {
        $id = (int) ($_POST['id'] ?? 0);
        $usedBy = (int) Database::scalar("SELECT COUNT(*) FROM sale_items WHERE product_id=?", [$id]);
        if ($id <= 0) {
            $err = 'Neplatný produkt.';
        } elseif ($usedBy > 0) {
            $err = 'Produkt má ' . $usedBy . ' prodaných položek — nelze smazat (kvůli historii a voucherům). Můžeš ho deaktivovat.';
        } else {
            $img = (string) (Database::scalar("SELECT image_path FROM products WHERE id=?", [$id]) ?? '');
            $pdo = Database::pdo(); $pdo->beginTransaction();
            try {
                $pdo->prepare("DELETE FROM product_categories WHERE product_id=?")->execute([$id]);
                $pdo->prepare("DELETE FROM product_pins WHERE product_id=?")->execute([$id]);
                $pdo->prepare("DELETE FROM product_schedules WHERE product_id=?")->execute([$id]);
                $pdo->prepare("DELETE pr FROM prices pr JOIN pricing_versions v ON v.id=pr.pricing_version_id WHERE v.product_id=?")->execute([$id]);
                $pdo->prepare("DELETE FROM pricing_versions WHERE product_id=?")->execute([$id]);
                $pdo->prepare("DELETE FROM pricing_dimensions WHERE product_id=?")->execute([$id]);
                $pdo->prepare("DELETE FROM products WHERE id=?")->execute([$id]);
                $pdo->commit();
                if ($img !== '') { delete_product_image($img); }
                audit_prod($a, 'product.delete', $id);
                redirect('/admin/products.php?deleted=1');
            } catch (Throwable $ex) { $pdo->rollBack(); $err = 'Smazání selhalo: ' . $ex->getMessage(); }
        }
    }
    if ($do === 'bulk') {
        $ids = array_values(array_filter(array_map('intval', (array) ($_POST['ids'] ?? [])), fn($x) => $x > 0));
        $act = (string) ($_POST['bulk'] ?? '');
        if ($ids && in_array($act, ['activate','deactivate'], true)) {
            $st = $act === 'activate' ? 'active' : 'inactive';
            $ph = implode(',', array_fill(0, count($ids), '?'));
            Database::pdo()->prepare("UPDATE products SET status=? WHERE id IN ($ph)")->execute(array_merge([$st], $ids));
            audit_prod($a, 'product.bulk.' . $act, 0);
            $msg = count($ids) . ' ' . (count($ids) === 1 ? 'produkt' : 'produktů') . ' ' . ($act === 'activate' ? 'aktivováno' : 'deaktivováno') . '.';
        } else {
            $err = 'Vyber aspoň jeden produkt a akci.';
        }
    }
}

// data
$agencies = Database::all("SELECT id,name FROM agencies WHERE status='active' ORDER BY name");
$allCats  = Database::all("SELECT id,name_cs FROM categories WHERE status='active' ORDER BY sort_order,name_cs");
// ---- filtry (search + agentura + kategorie + kontingent + svoz + stav + řazení) ----
$fq      = trim((string) ($_GET['q'] ?? ''));
$fAgency = (int) ($_GET['agency'] ?? 0);
$fCat    = (int) ($_GET['cat'] ?? 0);
$fCont   = (string) ($_GET['cont'] ?? '');     // '' | '1' (má kontingent) | '0' (na rezervaci)
$fPickup = (string) ($_GET['pickup'] ?? '');   // '' | '1' (se svozem) | '0' (bez svozu)
$fStatus = (string) ($_GET['status'] ?? '');   // '' | active | archived | inactive
$fSort   = (string) ($_GET['sort'] ?? 'name'); // name | agency | new

$wh = []; $pr = [];
if ($fq !== '') {
    $wh[] = '(p.name_cs LIKE ? OR p.name_en LIKE ? OR p.name_de LIKE ? OR a.name LIKE ?)';
    $like = '%' . $fq . '%'; array_push($pr, $like, $like, $like, $like);
}
if ($fAgency > 0) { $wh[] = 'a.id = ?'; $pr[] = $fAgency; }
if ($fCat > 0)    { $wh[] = 'EXISTS (SELECT 1 FROM product_categories pc WHERE pc.product_id=p.id AND pc.category_id=?)'; $pr[] = $fCat; }
if ($fCont === '1' || $fCont === '0')     { $wh[] = 'p.has_contingent = ?';    $pr[] = (int) $fCont; }
if ($fPickup === '1' || $fPickup === '0') { $wh[] = 'p.pickup_available = ?';  $pr[] = (int) $fPickup; }
if (in_array($fStatus, ['active','archived','inactive'], true)) { $wh[] = 'p.status = ?'; $pr[] = $fStatus; }
$whereSql = $wh ? ('WHERE ' . implode(' AND ', $wh)) : '';
$orderSql = $fSort === 'agency' ? 'a.name, p.name_cs'
          : ($fSort === 'new' ? 'p.id DESC' : "p.status='active' DESC, p.name_cs");
$filterActive = ($fq !== '' || $fAgency > 0 || $fCat > 0 || $fCont !== '' || $fPickup !== '' || $fStatus !== '');

$list = Database::all(
    "SELECT p.*, a.name AS agency_name FROM products p JOIN agencies a ON a.id=p.agency_id
     $whereSql ORDER BY $orderSql", $pr);
$edit = $editId ? (Database::all("SELECT * FROM products WHERE id=?", [$editId])[0] ?? null) : null;
$depHint = '';
if ($edit) {
    $r = Pricing::rates((int) $edit['id']);
    $pct = (float) ($r['commission_pct'] ?? 0);
    $fromC = Pricing::fromCzk((int) $edit['id']);
    if ($pct > 0) {
        $depHint = 'Z provize ' . rtrim(rtrim(number_format($pct, 2, '.', ''), '0'), '.') . ' %';
        if ($fromC !== null) {
            $depHint .= ' → záloha cca ' . number_format(round($fromC * $pct / 100), 0, ',', ' ')
                . ' Kč/os. (z nejnižší ceny ' . number_format($fromC, 0, ',', ' ') . ' Kč)';
        } else {
            $depHint .= ' (cena zatím nenastavena)';
        }
    }
}
$editCats = $edit ? array_map('intval', array_column(Database::all("SELECT category_id FROM product_categories WHERE product_id=?", [$edit['id']]), 'category_id')) : [];

// product → category names for list
$catsByProduct = [];
foreach (Database::all("SELECT pc.product_id, c.name_cs FROM product_categories pc JOIN categories c ON c.id=pc.category_id") as $r) {
    $catsByProduct[(int)$r['product_id']][] = $r['name_cs'];
}
// produkty s cenou / s rozvrhem (pro štítky „chybí nastavení")
$hasPrice = [];
foreach (Database::all("SELECT DISTINCT v.product_id pid FROM pricing_versions v JOIN prices pr ON pr.pricing_version_id=v.id WHERE v.status='active'") as $r) { $hasPrice[(int)$r['pid']] = true; }
$hasSched = [];
foreach (Database::all("SELECT DISTINCT product_id pid FROM product_schedules") as $r) { $hasSched[(int)$r['pid']] = true; }

$rows = '';
foreach ($list as $p) {
    $chip = $p['status'] === 'active' ? '<span class="chip chip-ok">active</span>'
        : ($p['status'] === 'archived' ? '<span class="chip chip-bad">archived</span>' : '<span class="chip chip-muted">inactive</span>');
    $tags = '';
    foreach ($catsByProduct[(int)$p['id']] ?? [] as $cn) { $tags .= '<span class="tag">' . e($cn) . '</span>'; }
    $dur = $p['duration_minutes'] ? (int)$p['duration_minutes'] . ' min' : '—';
    $th = !empty($p['image_path'])
        ? '<img src="/uploads/' . e($p['image_path']) . '" alt="" class="pthumb">'
        : '<span class="pthumb-empty"></span>';
    $pid = (int) $p['id'];
    $setup = '';
    if (empty($hasPrice[$pid])) { $setup .= '<span class="flag-warn" title="Produkt nemá nastavenou aktivní cenu">bez ceny</span>'; }
    if (in_array($p['schedule_type'], ['fixed_daily','multiple_daily','weekly_pattern','seasonal','specific_dates'], true) && empty($hasSched[$pid])) {
        $setup .= '<span class="flag-info" title="Produkt s pevnými odjezdy nemá nastavený rozvrh (časy)">bez rozvrhu</span>';
    }
    $rows .= '<tr><td class="cbcell"><input type="checkbox" name="ids[]" value="' . $pid . '" form="bulkform"></td>'
           . '<td>' . $th . (!empty($p['is_featured']) ? '<span class="pin-star" title="Oblíbené">★</span> ' : '') . e($p['name_cs']) . '<div class="tags">' . $tags . $setup . '</div></td>'
           . '<td>' . e($p['agency_name']) . '</td>'
           . '<td class="muted">' . e(SCHEDULE[$p['schedule_type']] ?? $p['schedule_type']) . '</td>'
           . '<td class="mono">' . $dur . '</td>'
           . '<td>' . $chip . '</td>'
           . '<td class="actions"><a class="btn-s" href="?edit=' . (int)$p['id'] . '#prod-editor">Upravit</a> '
           . '<a class="btn-g" href="/admin/schedules.php?product=' . (int)$p['id'] . '">Rozvrh</a> '
           . '<a class="btn-s" href="/admin/pricing.php?product=' . (int)$p['id'] . '">Ceny</a> '
           . '<a class="btn-g" href="/product.php?id=' . (int)$p['id'] . '" target="_blank" rel="noopener">Náhled</a> '
           . '<form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="duplicate"><input type="hidden" name="id" value="' . (int)$p['id'] . '"><button class="btn-g" type="submit">Duplikovat</button></form> '
           . '<form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="feature"><input type="hidden" name="id" value="' . (int)$p['id'] . '"><button class="btn-g" type="submit">' . (!empty($p['is_featured']) ? 'Odepnout' : 'Připnout') . '</button></form> '
           . '<form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="toggle"><input type="hidden" name="id" value="' . (int)$p['id'] . '"><button class="btn-g" type="submit">' . ($p['status']==='active'?'Deaktivovat':'Aktivovat') . '</button></form> '
           . '<a class="btn-d" href="?delete=' . (int)$p['id'] . '">Smazat</a></td></tr>';
}
if ($rows === '') { $rows = '<tr><td colspan="7" class="muted">' . ($filterActive ? 'Žádný produkt neodpovídá filtru.' : 'zatím žádné produkty') . '</td></tr>'; }

// ---- form helpers ----
$v   = fn(string $k, $d='') => e((string) ($edit[$k] ?? $d));
$sel = function(array $map, string $field, string $cur): string {
    $h = ''; foreach ($map as $k=>$lbl) { $h .= '<option value="'.$k.'"'.($cur===$k?' selected':'').'>'.e($lbl).'</option>'; } return $h;
};
$agencyOpts = '';
foreach ($agencies as $ag) { $cur = (int)($edit['agency_id'] ?? 0); $agencyOpts .= '<option value="'.(int)$ag['id'].'"'.($cur===(int)$ag['id']?' selected':'').'>'.e($ag['name']).'</option>'; }
$catChecks = '';
foreach ($allCats as $c) { $on = in_array((int)$c['id'], $editCats, true) ? ' checked' : '';
    $catChecks .= '<label><input type="checkbox" name="categories[]" value="'.(int)$c['id'].'"'.$on.'>'.e($c['name_cs']).'</label>'; }
$ck = fn(string $k, $default=0) => (($edit[$k] ?? $default) ? ' checked' : '');
$LANG_LABELS = ['en'=>'Angličtina','de'=>'Němčina','fr'=>'Francouzština','es'=>'Španělština','it'=>'Italština','ru'=>'Ruština'];
$editLangOpts = $edit ? array_values(array_filter((array) (json_decode((string) ($edit['language_options'] ?? ''), true) ?: []), 'is_string')) : [];
$langOptChecks = '';
foreach ($LANG_LABELS as $code => $lbl) {
    $on = in_array($code, $editLangOpts, true) ? ' checked' : '';
    $langOptChecks .= '<label><input type="checkbox" name="language_options[]" value="' . $code . '"' . $on . '>' . e($lbl) . '</label>';
}
$addonsText = '';
foreach ((array)(json_decode((string)($edit['addons'] ?? ''), true) ?: []) as $ax) {
    if (empty($ax['label'])) continue;
    $addonsText .= $ax['label'] . '|' . rtrim(rtrim(number_format((float)($ax['czk'] ?? 0), 2, '.', ''), '0'), '.') . '|' . (isset($ax['eur']) && $ax['eur'] !== null ? rtrim(rtrim(number_format((float)$ax['eur'], 2, '.', ''), '0'), '.') : '') . "\n";
}
$addonsText = e(rtrim($addonsText, "\n"));

$noAgency = $agencies ? '' : '<div class="alert alert-err">Nejdřív vytvoř aspoň jednu agenturu (záložka Agentury) – produkt musí patřit agentuře.</div>';

// image block (thumbnail + upload + remove) — tělo karty „Obrázek"
$curImgPath = $edit['image_path'] ?? '';
$thumb = $curImgPath
    ? '<img src="/uploads/' . e($curImgPath) . '" alt="" class="pthumb-lg">'
      . '<label class="switches mb-10"><input type="checkbox" name="remove_image"> Odebrat obrázek</label>'
    : '<div class="inline-note mb-10">Zatím bez obrázku.</div>';
$imgBlock = $thumb
    . '<div class="field"><label>Nahrát / nahradit (JPG, PNG, WEBP, max 6 MB)</label>'
    . '<input type="file" name="image" accept="image/jpeg,image/png,image/webp"></div>'
    . '<div class="inline-note">Zobrazí se prodejci v detailu produktu pro vizuální kontrolu proti letáku, který drží zákazník.</div>';

// section-card helper (vize: mockup .adm-card). $title/$sub jsou literály (smí obsahovat <em>).
$card = function (string $no, string $title, string $sub, string $body): string {
    return '<section class="adm-card">'
      . '<div class="adm-card-h"><span class="adm-card-no">' . $no . '</span>'
      . '<div class="adm-card-ht"><div class="adm-card-title">' . $title . '</div>'
      . ($sub !== '' ? '<div class="adm-card-sub">' . $sub . '</div>' : '')
      . '</div></div>'
      . '<div class="adm-card-body">' . $body . '</div></section>';
};

$formTitle = $edit ? ('Upravit: <em>' . e((string) $edit['name_cs']) . '</em>') : 'Přidat <em>produkt</em>';
$savebarInfo = $edit
    ? 'Upravuješ <b>#' . (int) $edit['id'] . '</b> · ' . e((string) $edit['name_cs'])
    : 'Nový produkt — vyplň aspoň <b>název</b> a <b>agenturu</b>';

// --- 1) Základ produktu ---
$c1 = '<div class="grid-2">'
  . '<div class="field"><label>Název (CS)</label><input name="name_cs" value="'.$v('name_cs').'"></div>'
  . '<div class="field"><label>Agentura</label><select name="agency_id">'.$agencyOpts.'</select></div>'
  . '<div class="field"><label>Název (EN)</label><input name="name_en" value="'.$v('name_en').'"></div>'
  . '<div class="field"><label>Název (DE)</label><input name="name_de" value="'.$v('name_de').'"></div>'
  . '<div class="field fld-wide"><label>Jazyky (tour + audio)</label><input name="languages" value="'.$v('languages').'" placeholder="např. EN, DE  /  audio průvodce 16 jazyků"></div>'
  . '</div>'
  . '<div class="field"><label>Jazyky výkladu (objednatelné)</label><div class="checklist">'.$langOptChecks.'</div><div class="inline-note">Jazyky průvodce, které si turista může u tohoto výletu / okružní jízdy objednat. Prázdné = produkt jazyk neřeší. Prodejci se zobrazí jako volba a propíše se na voucher. (Pozn.: pole „Jazyky (tour + audio)" výše je jen popisný text.)</div></div>'
  . '<div class="field"><label>Kategorie</label><div class="checklist">'.$catChecks.'</div></div>'
  . '<div class="grid-2">'
  . '<div class="field"><label>Délka (min)</label><input name="duration_minutes" class="mono" value="'.$v('duration_minutes').'"></div>'
  . '<div class="field"><label>Typ rozvrhu</label><select name="schedule_type">'.$sel(SCHEDULE,'schedule_type',(string)($edit['schedule_type']??'on_demand')).'</select></div>'
  . '<div class="field"><label>Uplatnění voucheru</label><select name="voucher_redemption_type">'.$sel(REDEEM,'voucher_redemption_type',(string)($edit['voucher_redemption_type']??'direct_entry')).'</select></div>'
  . '<div class="field"><label>Typ tiketu</label><select name="ticket_type">'.$sel(TICKET,'ticket_type',(string)($edit['ticket_type']??'date_required')).'</select></div>'
  . '</div>';

// --- 3) Vyzvednutí ---
$c3 = '<div class="switches">'
  . '<label><input type="checkbox" name="pickup_available"'.$ck('pickup_available').'>Dostupné</label>'
  . '<label><input type="checkbox" name="pickup_required"'.$ck('pickup_required').'>Povinné</label>'
  . '<label><input type="checkbox" name="pickup_free"'.$ck('pickup_free',1).'>Zdarma</label>'
  . '</div>'
  . '<div class="grid-2 mt-12">'
  . '<div class="field"><label>Okno vyzvednutí (min)</label><input name="pickup_window_minutes" class="mono" value="'.$v('pickup_window_minutes').'"></div>'
  . '<div class="field"><label>Potvrzení vyzvednutí</label><select name="pickup_confirmation"><option value="">—</option>'.$sel(PCONF,'pickup_confirmation',(string)($edit['pickup_confirmation']??'')).'</select></div>'
  . '</div>';

// --- 4) Provize a bonus ---
$c4 = '<div class="grid-2">'
  . '<div class="field"><label>Provize firmy % (náš zisk)</label><input name="commission_pct" class="mono" value="'.$v('commission_pct').'" placeholder="zdědí z agentury"></div>'
  . '<div class="field"><label>Bonus prodejce % (z marže)</label><input name="seller_bonus_pct" class="mono" value="'.$v('seller_bonus_pct').'" placeholder="výchozí 10"></div>'
  . '</div>'
  . '<div class="inline-note">Prázdné = zdědí (provize z agentury, bonus 10 %). Lze přepsat i u konkrétní cenové verze. Sleva prodejce jde z naší provize a krátí i jeho bonus.</div>';

// --- 5) Popis ---
$c5 = '<div class="field"><label>Popis (CS)</label><textarea name="description_cs" class="ta-tall">'.$v('description_cs').'</textarea></div>'
  . '<div class="grid-2">'
  . '<div class="field"><label>Popis (EN)</label><textarea name="description_en" class="ta-tall">'.$v('description_en').'</textarea></div>'
  . '<div class="field"><label>Popis (DE)</label><textarea name="description_de" class="ta-tall">'.$v('description_de').'</textarea></div>'
  . '</div>';

// --- 6) Jak objednat ---
$c6 = '<label class="switches mb-10"><input type="checkbox" name="has_contingent"'.$ck('has_contingent').'> Má kontingent (skryje blok „Jak objednat")</label>'
  . '<div class="field"><label>Instrukce k objednání (přepíše agenturní default)</label><textarea name="order_instructions" placeholder="prázdné = zdědí z agentury">'.$v('order_instructions').'</textarea></div>'
  . '<div class="field"><label>Odkaz na program / rezervaci (URL)</label><input name="booking_url" value="'.$v('booking_url').'" placeholder="https://…"></div>'
  . '<div class="inline-note">Telefon/helpline se bere z kontaktu agentury. Blok se prodejci ukáže jen u produktů bez kontingentu.</div>';

// --- 7) Záloha ---
$c7 = '<div class="inline-note">Záloha = naše provize (počítá se z % provize). Tady ji volitelně přepíšeš na pevnou částku na osobu. Prázdné = z provize. Volba zálohy se u prodeje objeví jen u agentur s deposit modelem.</div>'
  . ($depHint ? '<div class="callout-amt">' . e($depHint) . '</div>' : '')
  . '<div class="grid-2">'
  . '<div class="field"><label>Fixní záloha / os. (Kč)</label><input name="deposit_fixed_czk" class="mono" value="'.$v('deposit_fixed_czk').'" placeholder="z provize"></div>'
  . '<div class="field"><label>Fixní záloha / os. (€)</label><input name="deposit_fixed_eur" class="mono" value="'.$v('deposit_fixed_eur').'" placeholder="z provize"></div>'
  . '</div>';

// --- 8) Místo srazu ---
$c8 = '<div class="field"><label>Adresa místa srazu / konání</label><input name="meeting_point_address" value="'.$v('meeting_point_address').'" placeholder="např. Rašínovo nábřeží 2, Praha 2"></div>'
  . '<div class="field"><label>Odkaz na mapu (volitelně; jinak se vytvoří z adresy)</label><input name="map_url" value="'.$v('map_url').'" placeholder="https://maps.google.com/…"></div>'
  . '<div class="field"><label>Poznámka k místu srazu (pokyn pod adresou)</label><input name="meeting_point_note" value="'.$v('meeting_point_note').'" placeholder="např. Dostavte se 15 min předem; hledejte stojan PTI."></div>'
  . '<div class="field"><label>Varianty místa srazu (volitelně, jedna na řádek: Popisek||Adresa) — prodejce vybere při prodeji</label><textarea name="meeting_options" rows="2" placeholder="Stop A||Staroměstské nám.&#10;Stop B||nám. Republiky 3">'.$v('meeting_options').'</textarea></div>';

// --- 9) Obsah voucheru ---
$c9 = '<div class="field"><label><input type="checkbox" name="seating" value="1"'.(!empty($edit['seating'])?' checked':'').'> Vstupenka se sezením (koncert/divadlo) – na prodejním místě lze zadat řadu/sedadla; prázdné = volné sezení</label></div>'
  . '<div class="field"><label>Doplňky / addony (volitelné, jeden na řádek: Popisek|cena Kč|cena € — cena za osobu)</label><textarea name="addons" rows="3" class="ta-tall" placeholder="Special main course (upgrade)|75|3&#10;Hotel transfer (return minibus)|300|12">'.$addonsText.'</textarea></div>'
  . '<div class="grid-2">'
  . '<div class="field"><label>V ceně (jedna položka na řádek)</label><textarea name="included" rows="3" class="ta-tall" placeholder="Vstupné&#10;Audioprůvodce&#10;Anglicky mluvící průvodce">'.$v('included').'</textarea></div>'
  . '<div class="field"><label>Není v ceně (jedna položka na řádek)</label><textarea name="excluded" rows="3" class="ta-tall" placeholder="Spropitné&#10;Svoz z hotelu&#10;Jídlo a nápoje">'.$v('excluded').'</textarea></div>'
  . '</div>'
  . '<div class="field"><label>Vezměte s sebou (jedna položka na řádek)</label><textarea name="what_to_bring" rows="2" placeholder="Tento voucher&#10;Doklad totožnosti">'.$v('what_to_bring').'</textarea></div>'
  . '<div class="field"><label>Důležité informace (omezení, dress code, přístupnost…)</label><textarea name="important_info" rows="2">'.$v('important_info').'</textarea></div>'
  . '<div class="field"><label>Storno podmínky</label><input name="cancellation_policy" value="'.$v('cancellation_policy').'" placeholder="např. Bezplatné storno do 24 h před začátkem; poté nevratné."></div>'
  . '<div class="inline-note">Zobrazí se na PDF voucheru i s QR kódem na Google Maps.</div>';

$form = '<div class="adm-editor" id="prod-editor">'
  . '<div class="adm-editor-head"><h3>' . $formTitle . '</h3>'
  . ($edit ? '<div class="editor-links"><a class="btn-s" href="/admin/pricing.php?product=' . (int) $edit['id'] . '">Upravit ceny</a> <a class="btn-s" href="/admin/schedules.php?product=' . (int) $edit['id'] . '">Upravit rozvrh</a> <a class="btn-g" href="/product.php?id=' . (int) $edit['id'] . '" target="_blank" rel="noopener">Náhled jako prodejce ↗</a></div>' : '')
  . '</div>'
  . $noAgency
  . '<form method="post" enctype="multipart/form-data">' . Csrf::field() . '<input type="hidden" name="do" value="save"><input type="hidden" name="id" value="' . ($edit?(int)$edit['id']:0) . '">'
  . $card('1', 'Základ produktu', 'Identita, jazyky, kategorie, rozvrh', $c1)
  . $card('2', 'Obrázek produktu', 'Promo foto z letáku', $imgBlock)
  . $card('3', 'Vyzvednutí', 'Pickup / svoz z hotelu', $c3)
  . $card('4', 'Provize a bonus', 'Náš zisk + bonus prodejce', $c4)
  . $card('5', 'Popis', 'CS · EN · DE', $c5)
  . $card('6', 'Jak objednat', 'Prodejní detail, když není kontingent', $c6)
  . $card('7', 'Záloha', 'Deposit — přepis z provize', $c7)
  . $card('8', 'Místo srazu', 'Adresa, mapa, varianty — na voucher', $c8)
  . $card('9', 'Obsah voucheru', 'Sezení, doplňky, v ceně, info', $c9)
  . '<div class="adm-savebar">'
  . '<a class="btn-g" href="/admin/products.php">Zrušit</a>'
  . '<span class="adm-savebar-info">' . $savebarInfo . '</span>'
  . '<button type="submit" name="after" value="stay" class="btn-p"'.($agencies?'':' disabled').'>'.($edit?'Uložit':'Vytvořit').'</button>'
  . '<button type="submit" name="after" value="close" class="btn-s"'.($agencies?'':' disabled').'>Uložit a zavřít</button>'
  . '</div>'
  . '</form></div>';

$msgHtml = $msg ? '<div class="alert alert-ok">' . e($msg) . '</div>' : '';
$errHtml = $err ? '<div class="alert alert-err">' . e($err) . '</div>' : '';

// ---- filtrovací lišta ----
$optSel = function (array $opts, string $cur): string {
    $h = ''; foreach ($opts as $val => $lbl) { $h .= '<option value="' . e((string) $val) . '"' . ((string) $val === $cur ? ' selected' : '') . '>' . e($lbl) . '</option>'; } return $h;
};
$agOpts = ['0' => 'Všechny agentury'];
foreach ($agencies as $ag) { $agOpts[(string) (int) $ag['id']] = $ag['name']; }
$catOpts = ['0' => 'Všechny kategorie'];
foreach ($allCats as $c) { $catOpts[(string) (int) $c['id']] = $c['name_cs']; }

$filterBar = '<form method="get" class="prod-filter">'
    . '<input type="search" name="q" value="' . e($fq) . '" placeholder="Hledat název nebo agenturu…" class="pf-search">'
    . '<select name="agency">' . $optSel($agOpts, (string) $fAgency) . '</select>'
    . '<select name="cat">' . $optSel($catOpts, (string) $fCat) . '</select>'
    . '<select name="cont">' . $optSel(['' => 'Kontingent: vše', '1' => 'Má kontingent', '0' => 'Na rezervaci'], $fCont) . '</select>'
    . '<select name="pickup">' . $optSel(['' => 'Svoz: vše', '1' => 'Se svozem', '0' => 'Bez svozu'], $fPickup) . '</select>'
    . '<select name="status">' . $optSel(['' => 'Stav: vše', 'active' => 'Aktivní', 'inactive' => 'Neaktivní', 'archived' => 'Archivované'], $fStatus) . '</select>'
    . '<select name="sort">' . $optSel(['name' => 'Název A–Z', 'agency' => 'Podle agentury', 'new' => 'Naposledy přidané'], $fSort) . '</select>'
    . '<button type="submit" class="btn-p">Filtrovat</button>'
    . ($filterActive ? '<a class="btn-g" href="/admin/products.php">Zrušit filtry</a>' : '')
    . '</form>'
    . '<div class="pf-count muted">Zobrazeno: ' . count($list) . ($filterActive ? ' (filtrováno)' : '') . '</div>';

// hromadné akce — formulář mimo tabulku, checkboxy se k němu vážou přes form="bulkform"
$bulkBar = '<form method="post" id="bulkform" class="bulk-bar">' . Csrf::field()
    . '<input type="hidden" name="do" value="bulk">'
    . '<span class="bulk-l">Hromadně s vybranými:</span>'
    . '<button type="submit" name="bulk" value="activate" class="btn-s">Aktivovat</button>'
    . '<button type="submit" name="bulk" value="deactivate" class="btn-g">Deaktivovat</button>'
    . '</form>';

$listBlock = $filterBar . $bulkBar
    . '<table class="table"><thead><tr><th class="cbcell"></th><th>Produkt</th><th>Agentura</th><th>Rozvrh</th><th>Délka</th><th>Stav</th><th></th></tr></thead><tbody>' . $rows . '</tbody></table>';

// potvrzení mazání (dvoukrokové, bez JS)
$confirmBanner = '';
if ($deleteId > 0) {
    $dp = Database::all("SELECT p.name_cs, a.name agency FROM products p JOIN agencies a ON a.id=p.agency_id WHERE p.id=?", [$deleteId])[0] ?? null;
    if ($dp) {
        $used = (int) Database::scalar("SELECT COUNT(*) FROM sale_items WHERE product_id=?", [$deleteId]);
        if ($used > 0) {
            $confirmBanner = '<div class="alert alert-err">Produkt <strong>' . e($dp['name_cs']) . '</strong> má ' . $used . ' prodaných položek — nelze smazat (historie a vouchery). Můžeš ho <strong>deaktivovat</strong>. <a class="btn-g" href="/admin/products.php">Zpět</a></div>';
        } else {
            $confirmBanner = '<div class="alert alert-warn confirm-del"><div>Opravdu trvale smazat <strong>' . e($dp['name_cs']) . '</strong> (' . e($dp['agency']) . ')? Tahle akce je nevratná.</div>'
                . '<div class="confirm-del-acts"><form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="delete"><input type="hidden" name="id" value="' . $deleteId . '"><button type="submit" class="btn-d">Ano, smazat trvale</button></form>'
                . '<a class="btn-g" href="/admin/products.php">Zrušit</a></div></div>';
        }
    }
}
$noteBlock = '<p class="inline-note mt-18">Ceny a <strong>cenové dimenze</strong> (varianta, sezóna, velikost skupiny…) přidáme produktu v dalším kroku, až postavíme cenové schéma.</p>';
$head = '<div class="prod-head"><h1>Produkty</h1>'
    . '<a class="btn-p" href="/admin/products.php#prod-editor">+ Přidat produkt</a></div>';
$bodyMain = $edit
    ? ($form . $listBlock . $noteBlock)        // úprava → editor nahoře
    : ($listBlock . $form . $noteBlock);       // jinak → seznam, pak formulář pro přidání

View::shell('Produkty', $a,
    View::adminNav('products')
    . $head . $msgHtml . $errHtml . $confirmBanner
    . $bodyMain,
    ['subtitle' => 'administrace', 'logout' => '/admin/?action=logout']);
