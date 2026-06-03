<?php
declare(strict_types=1);

/** Cart (§6): items added in the session, with customer totals. Remove items,
 *  continue to payment. Seller sees customer prices only. */

define('PTI_BASE', __DIR__ . '/app');
require PTI_BASE . '/bootstrap.php';
Session::start();
Csrf::require();
if (!Auth::isStation() || Auth::expired()) { redirect("/"); }
$a = Auth::actor();
$tenant = Auth::tenantById((int) $a['tenant_id']);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $do = $_POST['do'] ?? '';
    if ($do === 'remove') {
        $lid = (string) ($_POST['lid'] ?? '');
        $_SESSION['cart'] = array_values(array_filter($_SESSION['cart'] ?? [], fn($i) => $i['lid'] !== $lid));
        redirect('/cart.php');
    }
    if ($do === 'clear') { unset($_SESSION['cart']); redirect('/cart.php'); }
}

$cart = $_SESSION['cart'] ?? [];
$added = isset($_GET['added']);

function czk($n): string { return number_format((float)$n, 0, ',', ' ') . ' Kč'; }
function eur($n): string { return $n === null ? '' : number_format((float)$n, 0, ',', ' ') . ' €'; }

$rows = ''; $sumC = 0.0; $sumE = 0.0; $anyE = false;
foreach ($cart as $it) {
    $q = $it['q'];
    $sumC += (float) $q['customer_czk'];
    if ($q['customer_eur'] !== null) { $sumE += (float) $q['customer_eur']; $anyE = true; }
    $chips = '';
    foreach ($it['chosen'] as $c) { $chips .= '<span class="chip-sm">' . e($c['value']) . '</span>'; }
    $meta = $chips;
    $meta .= ' ' . (int) $it['qty'] . '×';
    if ((float) $it['discount_pct'] > 0) { $meta .= ' · sleva ' . rtrim(rtrim(number_format((float)$it['discount_pct'],2,'.',''),'0'),'.') . ' %'; }
    if (!empty($it['ticket_date'])) { $meta .= ' · ' . e($it['ticket_date']) . (!empty($it['ticket_time']) ? ' ' . e($it['ticket_time']) : ''); }
    $thumb = !empty($it['image_path'])
        ? '<img class="cart-thumb" src="/uploads/' . e($it['image_path']) . '" alt="">'
        : '<div class="cart-thumb-x"></div>';
    $rows .= '<div class="cart-item">' . $thumb
        . '<div class="cart-main"><div class="cart-name">' . e($it['product_name']) . '</div>'
        . '<div class="pcard-ag">' . e($it['agency']) . '</div>'
        . '<div class="cart-meta">' . $meta . '</div>'
        . '<form method="post" class="inline-form mt-12">' . Csrf::field()
        . '<input type="hidden" name="do" value="remove"><input type="hidden" name="lid" value="' . e($it['lid']) . '">'
        . '<button class="btn-g" type="submit">Odebrat</button></form></div>'
        . '<div class="cart-price"><div class="cart-price-czk">' . czk($q['customer_czk']) . '</div>'
        . '<div class="cart-price-eur">' . eur($q['customer_eur']) . '</div></div>'
        . '</div>';
}

if (!$cart) {
    $body = '<h1>Košík</h1><div class="cart-empty">Košík je prázdný.<br><a class="btn-p mt" href="/">Procházet katalog</a></div>';
} else {
    $body = ($added ? '<div class="alert alert-ok">Přidáno do košíku.</div>' : '')
        . '<div class="bld-head"><h1>Košík</h1></div>'
        . $rows
        . '<div class="cart-sum"><span>Celkem pro zákazníka</span>'
        . '<span class="cart-sum-czk">' . czk($sumC) . '</span>'
        . ($anyE ? '<span class="cart-price-eur">' . eur($sumE) . '</span>' : '') . '</div>'
        . '<div class="savebar cart-actions"><a class="btn-p" href="/payment.php">Pokračovat k platbě →</a>'
        . '<a class="btn-s" href="/">Přidat další</a>'
        . '<form method="post" class="inline-form">' . Csrf::field() . '<input type="hidden" name="do" value="clear">'
        . '<button class="btn-g" type="submit">Vyprázdnit</button></form></div>';
}

View::shell('Košík', $a, $body,
    ['tenant'=>$tenant['name']??null,'subtitle'=>'prodejní místo','logout'=>'/?action=logout']);
