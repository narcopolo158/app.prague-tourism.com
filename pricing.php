<?php
declare(strict_types=1);

/** Admin → Ceny (pricing workspace for one product):
 *  - manage pricing DIMENSIONS (axes + values)
 *  - manage pricing VERSIONS (draft/active/archived)
 *  The matrix grid editor itself is the next sub-step (4b). */

define('PTI_BASE', dirname(__DIR__) . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
$a = Auth::requireAdmin('/admin/');

const DIM_TYPES = ['variant'=>'Varianta','season'=>'Sezóna','group_size_tier'=>'Velikost skupiny',
    'passenger_type'=>'Typ pasažéra','seating'=>'Sezení','pricing_mode'=>'Režim ceny'];

$pid = (int) ($_GET['product'] ?? 0);
$product = $pid ? (Database::all("SELECT p.*, ag.name AS agency_name FROM products p JOIN agencies ag ON ag.id=p.agency_id WHERE p.id=?", [$pid])[0] ?? null) : null;
if (!$product) { http_response_code(404); View::shell('Ceny', $a, View::adminNav('products') . '<h1>Produkt nenalezen</h1><p><a href="/admin/products.php">← Produkty</a></p>', ['logout'=>'/admin/?action=logout']); }

function audit_pr(array $a, string $action, int $id): void {
    Database::pdo()->prepare("INSERT INTO audit_log (actor_type,actor_id,action,target_type,target_id,ip_address) VALUES ('admin',?,?,'pricing',?,?)")
        ->execute([(int)$a['id'], $action, (string)$id, client_ip()]);
}

$msg = ''; $err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $do = $_POST['do'] ?? '';

    // ---- dimensions ----
    if ($do === 'dim_save') {
        $did    = (int) ($_POST['dim_id'] ?? 0);
        $type   = array_key_exists($_POST['type'] ?? '', DIM_TYPES) ? $_POST['type'] : 'variant';
        $label  = trim($_POST['label'] ?? '');
        $raw    = (string) ($_POST['values'] ?? '');
        $values = array_values(array_filter(array_map('trim', preg_split('/\r\n|\r|\n/', $raw)), fn($v) => $v !== ''));
        $sort   = (int) ($_POST['sort_order'] ?? 0);
        if ($label === '')        $err = 'Zadej název dimenze.';
        elseif (count($values) < 1) $err = 'Zadej aspoň jednu hodnotu (každou na řádek).';
        if (!$err) {
            $json = json_encode($values, JSON_UNESCAPED_UNICODE);
            if ($did > 0) {
                Database::pdo()->prepare("UPDATE pricing_dimensions SET type=?,label=?,values_json=?,sort_order=? WHERE id=? AND product_id=?")
                    ->execute([$type,$label,$json,$sort,$did,$pid]);
                audit_pr($a,'dimension.update',$did); $msg = 'Dimenze uložena.';
            } else {
                Database::pdo()->prepare("INSERT INTO pricing_dimensions (product_id,type,label,values_json,sort_order) VALUES (?,?,?,?,?)")
                    ->execute([$pid,$type,$label,$json,$sort]);
                audit_pr($a,'dimension.create',(int)Database::pdo()->lastInsertId()); $msg = 'Dimenze přidána.';
            }
        }
    }
    if ($do === 'dim_delete') {
        $did = (int) ($_POST['dim_id'] ?? 0);
        Database::pdo()->prepare("DELETE FROM pricing_dimensions WHERE id=? AND product_id=?")->execute([$did,$pid]);
        audit_pr($a,'dimension.delete',$did); $msg = 'Dimenze smazána.';
    }

    // ---- versions ----
    if ($do === 'ver_create') {
        $name = trim($_POST['name'] ?? '');
        $from = ($_POST['effective_from'] ?? '') ?: null;
        $to   = ($_POST['effective_to'] ?? '') ?: null;
        $vc   = ($_POST['commission_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['commission_pct']);
        $vb   = ($_POST['seller_bonus_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['seller_bonus_pct']);
        if ($name === '') $err = 'Zadej název verze (např. „léto 2026").';
        else {
            Database::pdo()->prepare("INSERT INTO pricing_versions (product_id,name,effective_from,effective_to,commission_pct,seller_bonus_pct,status) VALUES (?,?,?,?,?,?,'draft')")
                ->execute([$pid,$name,$from,$to,$vc,$vb]);
            audit_pr($a,'version.create',(int)Database::pdo()->lastInsertId()); $msg = 'Verze vytvořena (draft).';
        }
    }
    if ($do === 'ver_overrides') {
        $vid = (int) ($_POST['ver_id'] ?? 0);
        $vc  = ($_POST['commission_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['commission_pct']);
        $vb  = ($_POST['seller_bonus_pct'] ?? '') === '' ? null : (float) str_replace(',', '.', (string) $_POST['seller_bonus_pct']);
        Database::pdo()->prepare("UPDATE pricing_versions SET commission_pct=?, seller_bonus_pct=? WHERE id=? AND product_id=?")
            ->execute([$vc,$vb,$vid,$pid]);
        audit_pr($a,'version.overrides',$vid); $msg = 'Provize/bonus verze uloženy.';
    }
    if ($do === 'ver_status') {
        $vid = (int) ($_POST['ver_id'] ?? 0);
        $st  = in_array($_POST['status'] ?? '', ['draft','active','archived'], true) ? $_POST['status'] : 'draft';
        Database::pdo()->prepare("UPDATE pricing_versions SET status=? WHERE id=? AND product_id=?")->execute([$st,$vid,$pid]);
        audit_pr($a,'version.status.'.$st,$vid); $msg = 'Stav verze změněn na ' . $st . '.';
    }
}

// data
$dims = Database::all("SELECT * FROM pricing_dimensions WHERE product_id=? ORDER BY sort_order,id", [$pid]);
$vers = Database::all("SELECT * FROM pricing_versions WHERE product_id=? ORDER BY status='active' DESC, id DESC", [$pid]);
$editDim = isset($_GET['dim']) ? (Database::all("SELECT * FROM pricing_dimensions WHERE id=? AND product_id=?", [(int)$_GET['dim'],$pid])[0] ?? null) : null;

// matrix size estimate
$cells = 1; foreach ($dims as $d) { $vals = json_decode($d['values_json'], true) ?: []; $cells *= max(1, count($vals)); }

// ---- dimensions UI ----
$dimRows = '';
foreach ($dims as $d) {
    $vals = json_decode($d['values_json'], true) ?: [];
    $chips = '';
    foreach ($vals as $v) { $chips .= '<span class="tag">' . e($v) . '</span>'; }
    $dimRows .= '<div class="dim-row"><div class="dim-main">'
        . '<div class="dim-type">' . e(DIM_TYPES[$d['type']] ?? $d['type']) . '</div>'
        . '<div class="dim-label">' . e($d['label']) . ' <span class="muted mono cat-sub">(' . count($vals) . ')</span></div>'
        . '<div class="tags">' . $chips . '</div></div>'
        . '<div class="actions"><a class="btn-s" href="?product=' . $pid . '&dim=' . (int)$d['id'] . '">Upravit</a> '
        . '<form method="post" class="inline-form" data-confirm="Smazat dimenzi?">' . Csrf::field()
        . '<input type="hidden" name="do" value="dim_delete"><input type="hidden" name="dim_id" value="' . (int)$d['id'] . '">'
        . '<button class="btn-g" type="submit">Smazat</button></form></div></div>';
}
if ($dimRows === '') { $dimRows = '<p class="muted">Zatím žádné dimenze. Jednoduchý produkt může mít jednu dimenzi (např. „Typ pasažéra" s hodnotami Dospělý / Dítě), složitý víc (Mozart: balíček × sezení × sezóna).</p>'; }

$dt = $editDim['type'] ?? 'variant';
$typeOpts = '';
foreach (DIM_TYPES as $k=>$lbl) { $typeOpts .= '<option value="'.$k.'"'.($dt===$k?' selected':'').'>'.e($lbl).'</option>'; }
$dimValsText = $editDim ? e(implode("\n", json_decode($editDim['values_json'], true) ?: [])) : '';
$dimForm = '<section class="adm-card"><div class="adm-card-h"><span class="adm-card-no">+</span>'
    . '<div class="adm-card-ht"><div class="adm-card-title">' . ($editDim?'Upravit dimenzi':'Přidat dimenzi') . '</div>'
    . '<div class="adm-card-sub">Osa ceny (varianta, sezóna, typ pasažéra…) a její hodnoty</div></div></div>'
    . '<div class="adm-card-body">'
    . '<form method="post">' . Csrf::field() . '<input type="hidden" name="do" value="dim_save"><input type="hidden" name="dim_id" value="' . ($editDim?(int)$editDim['id']:0) . '">'
    . '<div class="grid-2">'
    . '<div class="field"><label>Typ</label><select name="type">' . $typeOpts . '</select></div>'
    . '<div class="field"><label>Pořadí (osa)</label><input name="sort_order" class="mono" value="' . e((string)($editDim['sort_order'] ?? count($dims))) . '"></div>'
    . '</div>'
    . '<div class="field"><label>Název (popisek osy)</label><input name="label" value="' . e($editDim['label'] ?? '') . '" placeholder="Typ pasažéra"></div>'
    . '<div class="field"><label>Hodnoty (každá na samostatný řádek)</label><textarea name="values" class="ta-tall">' . $dimValsText . '</textarea></div>'
    . '<button class="btn-p" type="submit">' . ($editDim?'Uložit dimenzi':'Přidat dimenzi') . '</button> '
    . ($editDim ? '<a class="btn-g" href="?product=' . $pid . '">Zrušit</a>' : '')
    . '</form></div></section>';

// ---- versions UI (karty do pravého sidebaru) ----
$pnz = fn($x) => $x === null || $x === '' ? '' : rtrim(rtrim(number_format((float)$x, 2, '.', ''), '0'), '.');
$base = Pricing::rates($pid, null);  // inherited (product → agency / default bonus)
$verRows = '';
foreach ($vers as $vv) {
    $st = $vv['status'];
    $rowCls = $st === 'active' ? ' is-active' : ($st === 'draft' ? ' is-draft' : '');
    $tagCls = ['draft'=>'t-draft','active'=>'t-active','archived'=>'t-archived'][$st] ?? 't-draft';
    $tagLbl = ['draft'=>'draft','active'=>'aktivní','archived'=>'archiv'][$st] ?? $st;
    $dates  = trim(($vv['effective_from'] ?? '') . ($vv['effective_to'] ? ' – ' . $vv['effective_to'] : ''));
    $btns = '';
    foreach (['draft'=>'Draft','active'=>'Aktivovat','archived'=>'Archivovat'] as $s=>$lbl) {
        if ($s === $st) continue;
        $btns .= '<form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="ver_status"><input type="hidden" name="ver_id" value="' . (int)$vv['id'] . '"><input type="hidden" name="status" value="' . $s . '"><button class="btn-g" type="submit">' . $lbl . '</button></form>';
    }
    $ovForm = '<form method="post" class="ver-ov">' . Csrf::field()
        . '<input type="hidden" name="do" value="ver_overrides"><input type="hidden" name="ver_id" value="' . (int)$vv['id'] . '">'
        . '<span class="ver-ov-l">prov./bonus %</span>'
        . '<input name="commission_pct" class="mono num-mini" value="' . e($pnz($vv['commission_pct'] ?? null)) . '" placeholder="' . e($pnz($base['commission_pct'])) . '" title="Provize firmy %">'
        . '<input name="seller_bonus_pct" class="mono num-mini" value="' . e($pnz($vv['seller_bonus_pct'] ?? null)) . '" placeholder="' . e($pnz($base['seller_bonus_pct'])) . '" title="Bonus prodejce %">'
        . '<button class="btn-g" type="submit" title="Uložit provizi/bonus">✓</button></form>';
    $verRows .= '<div class="ver-row' . $rowCls . '">'
        . '<div class="ver-row-h"><span class="ver-row-name">' . e($vv['name']) . '</span><span class="ver-row-tag ' . $tagCls . '">' . e($tagLbl) . '</span></div>'
        . '<div class="ver-row-meta">' . ($dates ? e($dates) : 'bez období') . '</div>'
        . $ovForm
        . '<div class="ver-row-acts"><a class="btn-s" href="/admin/matrix.php?version=' . (int)$vv['id'] . '">Upravit ceny →</a>' . $btns . '</div>'
        . '</div>';
}
if ($verRows === '') { $verRows = '<div class="ver-row"><div class="ver-row-meta">Zatím žádná cenová verze — vytvoř první níže.</div></div>'; }

$msgHtml = $msg ? '<div class="alert alert-ok">' . e($msg) . '</div>' : '';
$errHtml = $err ? '<div class="alert alert-err">' . e($err) . '</div>' : '';

$ic = fn(string $d) => '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' . $d . '</svg>';
$cellWord = (int)$cells === 1 ? 'buňka' : ((int)$cells < 5 ? 'buňky' : 'buněk');

$body = View::adminNav('products', ['actor' => $a])
    . '<div class="crumbs"><a href="/admin/products.php">Produkty</a> › Ceny</div>'
    . '<div class="adm-editor-head"><h3>' . e($product['name_cs']) . ' <em>· ' . e($product['agency_name']) . '</em></h3></div>'
    . $msgHtml . $errHtml
    . '<div class="pric-grid">'
    // ---- levý sloupec: dimenze ----
    . '<div class="pric-main">'
    . '<div class="pric-formula"><span>Matice cen:</span><span class="f">' . (int)$cells . ' ' . $cellWord . '</span>'
    . '<span class="note">součin hodnot všech dimenzí · ceny vyplníš u konkrétní verze</span></div>'
    . '<section class="adm-card"><div class="adm-card-h"><span class="adm-card-no">' . $ic('<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/>') . '</span>'
    . '<div class="adm-card-ht"><div class="adm-card-title">Cenové dimenze</div><div class="adm-card-sub">Co určuje cenu — osy matice</div></div>'
    . '<span class="adm-card-h-r">' . count($dims) . 'D</span></div>'
    . '<div class="adm-card-body">' . $dimRows . '</div></section>'
    . $dimForm
    . '</div>'
    // ---- pravý sloupec: verze ----
    . '<aside class="adm-rside">'
    . '<section class="adm-card"><div class="adm-card-h"><span class="adm-card-no">' . $ic('<path d="m12 2 9 5-9 5-9-5 9-5Z"/><path d="m3 12 9 5 9-5"/><path d="m3 17 9 5 9-5"/>') . '</span>'
    . '<div class="adm-card-ht"><div class="adm-card-title">Cenové verze</div><div class="adm-card-sub">draft · aktivní · archiv (snapshot)</div></div></div>'
    . '<div class="ver-list">' . $verRows . '</div></section>'
    . '<section class="adm-card"><div class="adm-card-h"><span class="adm-card-no">+</span>'
    . '<div class="adm-card-ht"><div class="adm-card-title">Nová verze</div><div class="adm-card-sub">Vytvoří se jako draft</div></div></div>'
    . '<div class="adm-card-body">'
    . '<form method="post">' . Csrf::field() . '<input type="hidden" name="do" value="ver_create">'
    . '<div class="field"><label>Název</label><input name="name" placeholder="léto 2026"></div>'
    . '<div class="grid-2"><div class="field"><label>Platí od</label><input type="date" name="effective_from"></div>'
    . '<div class="field"><label>Platí do</label><input type="date" name="effective_to"></div></div>'
    . '<div class="grid-2"><div class="field"><label>Provize firmy %</label><input name="commission_pct" class="mono" placeholder="' . e($pnz($base['commission_pct'])) . ' (zděděno)"></div>'
    . '<div class="field"><label>Bonus prodejce %</label><input name="seller_bonus_pct" class="mono" placeholder="' . e($pnz($base['seller_bonus_pct'])) . ' (zděděno)"></div></div>'
    . '<button class="btn-p" type="submit">Vytvořit verzi</button></form></div></section>'
    . '</aside>'
    . '</div>';

View::shell('Ceny – ' . $product['name_cs'], $a, $body, ['subtitle'=>'administrace','logout'=>'/admin/?action=logout']);
