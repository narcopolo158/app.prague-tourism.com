<?php
declare(strict_types=1);

/** Admin → pricing matrix editor for one version.
 *  Renders CZK/EUR inputs per matrix cell (Cartesian product of the product's
 *  dimensions): 0D single price, 1D list, 2D grid, 3D tabs+grid, 4D+ flat list.
 *  Saves to `prices` keyed by canonical cell_key. */

define('PTI_BASE', dirname(__DIR__) . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
$a = Auth::requireAdmin('/admin/');

$vid = (int) ($_GET['version'] ?? 0);
$ver = $vid ? (Database::all(
    "SELECT pv.*, p.id AS pid, p.name_cs FROM pricing_versions pv JOIN products p ON p.id=pv.product_id WHERE pv.id=?",
    [$vid])[0] ?? null) : null;
if (!$ver) { http_response_code(404); View::shell('Matice', $a, View::adminNav('products') . '<h1>Verze nenalezena</h1>', ['logout'=>'/admin/?action=logout']); }
$pid = (int) $ver['pid'];

// dimensions (ordered)
$dimRows = Database::all("SELECT * FROM pricing_dimensions WHERE product_id=? ORDER BY sort_order,id", [$pid]);
$dims = [];
foreach ($dimRows as $d) {
    $vals = json_decode($d['values_json'], true) ?: [];
    if ($vals) { $dims[] = ['id'=>(int)$d['id'], 'label'=>$d['label'], 'values'=>$vals]; }
}
$n = count($dims);

// canonical cell key from [dimId=>value]
function cell_key(array $assoc): string { ksort($assoc); return json_encode($assoc, JSON_UNESCAPED_UNICODE); }
// cartesian product -> list of [dimId=>value]
function cartesian(array $dims): array {
    $out = [[]];
    foreach ($dims as $d) {
        $next = [];
        foreach ($out as $combo) { foreach ($d['values'] as $v) { $c=$combo; $c[$d['id']]=$v; $next[]=$c; } }
        $out = $next;
    }
    return $out;
}

$msg = ''; $err = '';

// ---- save ----
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['do'] ?? '') === 'save_prices') {
    $keys = (array) ($_POST['key'] ?? []);
    $czks = (array) ($_POST['czk'] ?? []);
    $eurs = (array) ($_POST['eur'] ?? []);
    $validKeys = array_map(fn($c) => cell_key($c), cartesian($dims));
    $validSet = array_flip($validKeys);

    $pdo = Database::pdo();
    $pdo->beginTransaction();
    try {
        $up = $pdo->prepare(
            "INSERT INTO prices (pricing_version_id, cell_key, dimension_values_json, czk, eur, is_override)
             VALUES (?,?,?,?,?,0)
             ON DUPLICATE KEY UPDATE czk=VALUES(czk), eur=VALUES(eur)");
        $delKey = $pdo->prepare("DELETE FROM prices WHERE pricing_version_id=? AND cell_key=?");
        $set = 0;
        foreach ($keys as $i => $k) {
            if (!isset($validSet[$k])) { continue; } // ignore unknown keys
            $rawC = str_replace([' ', "\u{00a0}", ','], ['', '', '.'], (string)($czks[$i] ?? ''));
            $rawE = str_replace([' ', "\u{00a0}", ','], ['', '', '.'], (string)($eurs[$i] ?? ''));
            if ($rawC === '' || !is_numeric($rawC)) {
                $delKey->execute([$vid, $k]);           // cleared cell
                continue;
            }
            $czk = round((float)$rawC, 2);
            $eur = ($rawE !== '' && is_numeric($rawE)) ? round((float)$rawE, 2) : null;
            $up->execute([$vid, $k, $k, $czk, $eur]);
            $set++;
        }
        // orphan cleanup: drop price rows whose cell_key is no longer valid
        $existing = Database::all("SELECT cell_key FROM prices WHERE pricing_version_id=?", [$vid]);
        foreach ($existing as $exr) { if (!isset($validSet[$exr['cell_key']])) { $delKey->execute([$vid, $exr['cell_key']]); } }
        $pdo->commit();
        Database::pdo()->prepare("INSERT INTO audit_log (actor_type,actor_id,action,target_type,target_id,ip_address) VALUES ('admin',?,'pricing.matrix.save','version',?,?)")
            ->execute([(int)$a['id'], (string)$vid, client_ip()]);
        $msg = "Uloženo · vyplněno {$set} buněk.";
    } catch (Throwable $ex) { $pdo->rollBack(); $err = 'Uložení selhalo: ' . $ex->getMessage(); }
}

// ---- load existing prices ----
$priceMap = [];
foreach (Database::all("SELECT cell_key,czk,eur FROM prices WHERE pricing_version_id=?", [$vid]) as $pr) {
    $priceMap[$pr['cell_key']] = ['czk'=>$pr['czk'], 'eur'=>$pr['eur']];
}
$filled = count($priceMap);

// number display helper (trim trailing .00)
function pnum($v): string {
    if ($v === null || $v === '') return '';
    $s = rtrim(rtrim(number_format((float)$v, 2, '.', ''), '0'), '.');
    return $s;
}

// one cell's inputs (hidden key + czk + eur), returns HTML
function cell_inputs(string $key, array $priceMap): string {
    $p = $priceMap[$key] ?? null;
    $czk = $p ? pnum($p['czk']) : '';
    $eur = $p ? pnum($p['eur']) : '';
    return '<div class="mtx-cell">'
        . '<input type="hidden" name="key[]" value="' . e($key) . '">'
        . '<div class="mtx-in"><span class="cur">Kč</span><input name="czk[]" inputmode="decimal" value="' . e($czk) . '"></div>'
        . '<div class="mtx-in"><span class="cur">€</span><input name="eur[]" class="eur" inputmode="decimal" value="' . e($eur) . '"></div>'
        . '</div>';
}

// ---- build the editor body by dimensionality ----
$grid = '';
if ($n === 0) {
    $key = cell_key([]);
    $grid = '<div class="panel col-560"><div class="mtx-axislabel">Jednotná cena</div>'
          . '<div class="mtx-list">' . cell_inputs($key, $priceMap) . '</div></div>';
} elseif ($n === 1) {
    $d = $dims[0];
    $rows = '';
    foreach ($d['values'] as $v) {
        $key = cell_key([$d['id']=>$v]);
        $rows .= '<tr><th>' . e($v) . '</th><td>' . cell_inputs($key, $priceMap) . '</td></tr>';
    }
    $grid = '<div class="mtx-axislabel">' . e($d['label']) . '</div>'
          . '<div class="mtx-wrap mtx-list"><table class="mtx"><thead><tr><th class="mtx-corner">'
          . e($d['label']) . '</th><th>Cena</th></tr></thead><tbody>' . $rows . '</tbody></table></div>';
} elseif ($n === 2) {
    [$dr, $dc] = $dims;
    $head = '<tr><th class="mtx-corner">' . e($dr['label']) . ' \ ' . e($dc['label']) . '</th>';
    foreach ($dc['values'] as $cv) { $head .= '<th>' . e($cv) . '</th>'; }
    $head .= '</tr>';
    $body = '';
    foreach ($dr['values'] as $rv) {
        $body .= '<tr><th>' . e($rv) . '</th>';
        foreach ($dc['values'] as $cv) {
            $key = cell_key([$dr['id']=>$rv, $dc['id']=>$cv]);
            $body .= '<td>' . cell_inputs($key, $priceMap) . '</td>';
        }
        $body .= '</tr>';
    }
    $grid = '<div class="mtx-wrap"><table class="mtx"><thead>' . $head . '</thead><tbody>' . $body . '</tbody></table></div>';
} elseif ($n === 3) {
    [$dt, $dr, $dc] = $dims;
    $tabs = '<div class="mtx-axislabel">' . e($dt['label']) . '</div><div class="mtx-tabs" data-mtx-tabs="m">';
    foreach ($dt['values'] as $i=>$tv) {
        $tabs .= '<button type="button" class="mtx-tab' . ($i===0?' on':'') . '" data-mtx-tab="' . $i . '">' . e($tv) . '</button>';
    }
    $tabs .= '</div>';
    $panels = '';
    foreach ($dt['values'] as $i=>$tv) {
        $head = '<tr><th class="mtx-corner">' . e($dr['label']) . ' \ ' . e($dc['label']) . '</th>';
        foreach ($dc['values'] as $cv) { $head .= '<th>' . e($cv) . '</th>'; }
        $head .= '</tr>';
        $body = '';
        foreach ($dr['values'] as $rv) {
            $body .= '<tr><th>' . e($rv) . '</th>';
            foreach ($dc['values'] as $cv) {
                $key = cell_key([$dt['id']=>$tv, $dr['id']=>$rv, $dc['id']=>$cv]);
                $body .= '<td>' . cell_inputs($key, $priceMap) . '</td>';
            }
            $body .= '</tr>';
        }
        $panels .= '<div class="mtx-panel' . ($i===0?' on':'') . '" data-mtx-panel="m" data-mtx-idx="' . $i . '">'
                 . '<div class="mtx-wrap"><table class="mtx"><thead>' . $head . '</thead><tbody>' . $body . '</tbody></table></div></div>';
    }
    $grid = $tabs . $panels;
} else {
    // 4+ dimensions: flat list of all cells
    $labelById = [];
    foreach ($dims as $d) { $labelById[$d['id']] = $d['label']; }
    $head = '<tr>';
    foreach ($dims as $d) { $head .= '<th>' . e($d['label']) . '</th>'; }
    $head .= '<th>Cena</th></tr>';
    $body = '';
    foreach (cartesian($dims) as $combo) {
        $key = cell_key($combo);
        $body .= '<tr>';
        foreach ($dims as $d) { $body .= '<td>' . e((string)$combo[$d['id']]) . '</td>'; }
        $body .= '<td>' . cell_inputs($key, $priceMap) . '</td></tr>';
    }
    $grid = '<div class="mtx-wrap"><table class="mtx"><thead>' . $head . '</thead><tbody>' . $body . '</tbody></table></div>';
}

$cellCount = count(cartesian($dims));
$msgHtml = $msg ? '<div class="alert alert-ok">' . e($msg) . '</div>' : '';
$errHtml = $err ? '<div class="alert alert-err">' . e($err) . '</div>' : '';

$noDims = $n === 0
    ? '<div class="matrix-hint mb-10">Produkt nemá žádné dimenze – zadáváš jednu jednotnou cenu. '
      . 'Pokud chceš víc cen (dospělý/dítě, sezóny…), přidej dimenze v <a href="/admin/pricing.php?product=' . $pid . '">cenách produktu</a>.</div>'
    : '';

$statusChip = '<span class="ver-status ' . (['draft'=>'ver-draft','active'=>'ver-active','archived'=>'ver-archived'][$ver['status']] ?? 'ver-draft') . '">' . e($ver['status']) . '</span>';
$cellWord = $cellCount === 1 ? 'buňka' : ($cellCount < 5 ? 'buňky' : 'buněk');

// bulk toolbar (CSP-safe: data-mtx-bulk + inline SVG ikony; JS v app.js).
// U jednotné ceny (n===0) nedává smysl → skryjeme.
$ic = fn(string $d) => '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' . $d . '</svg>';
$toolbar = '';
if ($n >= 1) {
    $toolbar = '<div class="mtx-toolbar">'
        . '<span class="mtx-toolbar-l">Hromadně</span>'
        . '<button type="button" class="mtx-btn" data-mtx-bulk="pct">' . $ic('<line x1="19" y1="5" x2="5" y2="19"/><circle cx="6.5" cy="6.5" r="2.5"/><circle cx="17.5" cy="17.5" r="2.5"/>') . ' Upravit ± %</button>'
        . '<button type="button" class="mtx-btn" data-mtx-bulk="round">' . $ic('<path d="M12 19V6"/><path d="m6 12 6-6 6 6"/>') . ' Zaokrouhlit ↑</button>'
        . '<button type="button" class="mtx-btn" data-mtx-bulk="eur">' . $ic('<circle cx="12" cy="12" r="9"/><path d="M15 9.3a3.5 3.5 0 0 0-5 .7 4 4 0 0 0 0 4 3.5 3.5 0 0 0 5 .7"/><path d="M7 11h5"/><path d="M7 13h5"/>') . ' € z kurzu (prázdné)</button>'
        . '<button type="button" class="mtx-btn" data-mtx-bulk="clear">' . $ic('<path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M6 6v14a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V6"/>') . ' Vyčistit viditelné</button>'
        . '<span class="mtx-toolbar-r"><span class="mtx-chg" data-mtx-count hidden></span></span>'
        . '</div>';
}

$cardSub = 'Verze <strong>' . e($ver['name']) . '</strong> · ' . $statusChip . ' · '
    . $cellCount . ' ' . $cellWord . ' · vyplněno ' . $filled . ' · € je nepovinné';

$body = View::adminNav('products', ['actor' => $a])
    . '<div class="crumbs"><a href="/admin/products.php">Produkty</a> › <a href="/admin/pricing.php?product=' . $pid . '">' . e($ver['name_cs']) . '</a> › Matice</div>'
    . '<div class="adm-editor-head"><h3>Matice cen <em>· ' . e($ver['name_cs']) . '</em></h3></div>'
    . $msgHtml . $errHtml
    . $noDims
    . '<form method="post" data-matrix data-rate="25">' . Csrf::field() . '<input type="hidden" name="do" value="save_prices">'
    . '<section class="adm-card">'
    . '<div class="adm-card-h">'
    . '<span class="adm-card-no">' . $ic('<rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M3 15h18M9 3v18"/>') . '</span>'
    . '<div class="adm-card-ht"><div class="adm-card-title">Ceny v mřížce</div>'
    . '<div class="adm-card-sub">' . $cardSub . '</div></div>'
    . '</div>'
    . $toolbar
    . '<div class="adm-card-body">' . $grid . '</div>'
    . '</section>'
    . '<div class="adm-savebar">'
    . '<a class="btn-g" href="/admin/pricing.php?product=' . $pid . '">Zpět na ceny</a>'
    . '<span class="adm-savebar-info">Verze ' . e($ver['name']) . ' · prázdná buňka = kombinace se neuloží</span>'
    . '<button type="submit" class="btn-p">Uložit ceny</button>'
    . '</div>'
    . '</form>';

View::shell('Matice cen', $a, $body, ['subtitle'=>'administrace','logout'=>'/admin/?action=logout','js'=>true]);
