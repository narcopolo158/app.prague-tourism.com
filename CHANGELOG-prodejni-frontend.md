# PTI — UI/UX dodávka #6: Prodejní frontend (priorita č. 5 — §5)

Košík · platba · směna · prodeje. Mentalita dotykové stanice (vzdušné, velké plochy, CZK hlavní).
**Beze změny** názvů polí, datových toků, CSRF a PIN-flow. Etalony (`product.php`, `index.php`) nedotčeny.

## Změněné soubory (overlay)
- `payment.php` — **CSP oprava**: inline `style="font-weight:400;font-size:13px"` → třída `.h3-opt`.
  (Vizuální zvýraznění PIN kroku je čistě v CSS — markup beze změny.)
- `cart.php` — akční pruh `savebar` → `savebar cart-actions` (dotykově větší „Pokračovat k platbě").
- `sales.php` — seznam dostal **hlavičku** (Voucher · Zákazník · Vytvořeno · Platba · Celkem · Stav)
  a sloupec **způsobu platby** (`payment_method` už byl v `s.*` — žádná změna dotazu).
- `shift.php` — **beze změny PHP** (diff 0 ř.); jen se doplnily chybějící CSS třídy (viz níže),
  takže se teď renderuje správně.
- `assets/app.css` — přidán blok „prodejní frontend": `.h3-opt`, **doplněné `.dash-bonusbox`(+`.done`)
  a `.dash-browse`** (shift.php je používal, ale ve stylu chyběly), **zvýrazněný PIN blok**
  (`.pay-pin` jako orámovaný brandový „gate" s velkým monospace inputem), `.cart-actions`,
  hlavička+zebra prodejů (`.ps-head-row`, `.ps-row-pm`, zebra). Append, scoped, nepřepisuje stávající.
- `app/View.php` — sjednoceno s vaším handoffem (`adminNav` fallback `Auth::actor()`), žádná další změna.

> `app.css` / `app.js` jsou **kumulativní** (pricing matrix → #4 hustá tabulka → #5 frontend).
> Vše append-only, takže poslední verze obsahuje všechny dodávky a čistě se nasadí.

## Co se zlepšilo po obrazovkách
- **Košík:** dotykově větší primární CTA, jasnější oddělení součtu (CZK hlavní, € orientační).
- **Platba:** PIN prodejce je teď vizuálně **finální krok/gate** (orámovaný brandový blok se štítkem
  „PIN", velký monospace input), velké „Dokončit a vystavit voucher". Volba zálohy + stav doplatku
  (`data-pay-amount` / `balance-hot`) beze změny logiky.
- **Směna:** `dash-bonusbox` (potvrzení výplaty) a `dash-browse` se konečně stylují; přehled dne
  + bonus + dnešní prodeje drží rytmus dashboardu.
- **Prodeje:** čitelný seznam s hlavičkou, způsobem platby, stavovými odznaky (zaplaceno/stornováno),
  zebrou a dotykovými řádky; vyhledávání větší.

## Ověřeno (stub render každé obrazovky)
- `php -l` na všech 4 čistě; CSP sweep: žádné `style=`/`on*=`/`<script>`/`<style>` (payment inline opraven).
- Košík: 2 položky + `cart-actions` + součet. Platba: `pay-pin` blok, volba zálohy, `seller_pin`,
  `.h3-opt` a **inline_style=0**. Směna: `dash-shift` + `dash-bonusbox` + `dash-browse` + bonus.
  Prodeje: hlavička + sloupec platby (Hotovost/Karta) + 3 stavové odznaky + zebra. 0 redirectů (vše se vykreslilo).

Náhledy (inlinutý CSS+JS): `preview-kosik.html`, `preview-platba.html`, `preview-smena.html`, `preview-prodeje.html`.

## Pozn.
- „Tagy prodejce" v seznamu prodejů (§5.9) jsem **nepřidal** — vyžadovalo by to join na jméno prodejce,
  tedy změnu dotazu/datového toku. Pokud to chcete, doplníme po domluvě (jen vizuál z dat, která už načítáte).
