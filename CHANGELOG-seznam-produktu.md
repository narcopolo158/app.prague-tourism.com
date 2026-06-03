# PTI — UI/UX dodávka #5: Hustá tabulka v seznamu produktů (priorita č. 4)

Zadání §6.2. Bez zásahu do logiky, názvů polí, datových toků, CSRF, `form="bulkform"` vazby.

## Změněné soubory (overlay)
- `admin/products.php` — přestavěn **jen render řádku + třída tabulky** (seznam). Akce v řádku
  zhuštěny: 2 primární inline (**Upravit · Ceny**) + zbytek do **„•••" overflow menu** přes
  nativní `<details>/<summary>` (Rozvrh · Náhled ↗ · Duplikovat · Připnout/Odepnout ·
  Aktivovat/Deaktivovat · Smazat…). Všechny formuláře, `do=…`, `id`, CSRF, checkboxy
  `name="ids[]" form="bulkform"` i odkazy zůstaly **beze změny** (jen přeskupené).
- `assets/app.css` — přidán blok `.ptab` (zebra, **sticky hlavička** pod topbarem přes
  `--topbar-h`, sevřenější řádky, `overflow:visible` ať „•••" popup neořízne), `.rowmenu*`
  (CSP-safe menu), jemnější `.flag-warn/.flag-info` (tečka), elegantnější `.prod-filter`
  (karta místo holých polí). Nepřepisuje stávající `.table`.
- `assets/app.js` — přidán guardovaný modul: u `details.rowmenu` drží **jen jedno otevřené**,
  zavírá klikem mimo / Esc. Bez JS menu funguje taky (nativní `<details>`).

## Proč `<details>` místo JS dropdownu
Nativní `<details>/<summary>` je **CSP-safe, klávesově přístupné a funguje bez JS** —
přesně do prostředí s přísným CSP. JS jen přidává „zavři ostatní / klik mimo".

## Ověřeno (stub render celé stránky, 5 produktů)
- `php -l products.php` čistě; `node --check app.js` OK.
- `table ptab`, 5× `<details class="rowmenu">`, 5× delete/duplicate/feature/toggle formuláře,
  5× `ids[] form="bulkform"`, štítky „bez ceny" (3) / „bez rozvrhu" (3), ★ oblíbené (2).
- app.js i patička s uživatelem na stránce (admin auto-js z dodávky #3).
- CSP: žádné inline `style=`/`on*=`/`<script>`/`<style>`.

Náhled (inlinutý CSS+JS — zebra, sticky hlavička i „•••" menu fungují v prohlížeči):
`preview-seznam-produktu.html`.

## Pozn. k chování
Per-řádkový `do=toggle` jsem **zachoval přesně** jak byl (v `products.php` jsem nenašel jeho
handler — funkční cesta je hromadné Aktivovat/Deaktivovat). Logiky jsem se nedotýkal; pokud je
to záměr/řeší se jinde, nechávám beze změny.
