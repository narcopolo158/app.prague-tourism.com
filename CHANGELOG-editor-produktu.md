# PTI — UI/UX dodávka #1: Editor produktu (admin/products.php)

Priorita č. 1 ze zadání (§6.3 / §7). Cíl: sjednotit pořadí a vzhled sekcí,
líp zacházet s dlouhými poli, zpříjemnit každodenní editaci. **Bez zásahu do
business logiky, názvů polí, datových toků, CSRF, `after` ani anchorů.**

## Změněné soubory (overlay)
- `assets/app.css` — **přidán blok na konci** (žádná stávající pravidla nezměněna):
  `.adm-editor*`, `.adm-card*` (section-cards), `.adm-savebar*` (tmavý sticky savebar),
  `.fld-wide`, `.adm-card.is-dirty`. Vše přes tokeny z `:root`, CSP-safe.
- `admin/products.php` — **přestavěn jen blok `$form`** (+ `$imgBlock` jako tělo karty,
  + lokální helper `$card()`). Řádky 319–408 původního souboru. Zbytek beze změny.

## Co se vizuálně mění
- Plochý úzký `.panel col-820` s `.fieldset` boxy → **9 číslovaných section-cards**
  (Základ · Obrázek · Vyzvednutí · Provize a bonus · Popis · Jak objednat · Záloha ·
  Místo srazu · Obsah voucheru) — pořadí kopíruje strukturu product page.
- Hlavička karty: číslo sekce (vínový kruh) + Fraunces titulek s vínovým akcentem +
  mono podtitulek-nápověda. Sjednoceno s mockupem (`.adm-card`) i s `.pdx` etalonem.
- Editor rozšířen z 820 px na 1040 px; krátká pole v `.grid-2`, **dlouhé textové
  oblasti na plnou šířku a vyšší** (`.ta-tall`): popisy, addony, v ceně / není v ceně.
- **Tmavý sticky savebar** dole (vize z mockupu): Zrušit · stav · Uložit · Uložit a zavřít.
  Zlaté primary „Uložit" = nejčastější denní akce. Funguje čistě přes `position:sticky`,
  bez JS. `disabled` stav (žádná agentura) zachován.

## Rozhodnutí (klidně přehlasuj)
- Obrázek je samostatná karta č. 2 (zadání ho uvádí jako vlastní sekci).
- Primary v savebaru = „Uložit" (stay), „Uložit a zavřít" sekundární. Pokud chceš
  opačně, je to změna dvou tříd (`btn-p`↔`btn-s`).

## Volitelné (NEpovinné pro nasazení)
- `assets/app.js-additions.js` — vlož do `assets/app.js`. Přidá živé počítadlo
  „● N neuložených změn" do savebaru, zvýraznění rozpracované karty (`.is-dirty`)
  a varování při odchodu z neuložené stránky. CSP-safe (externí soubor, event delegation).
  **Aby se app.js na adminu načetl**, musí `View::shell(...)` pro admin stránky dostat
  `['js' => true]` (dnes ho `products.php` nevolá → `<script src="/assets/app.js" defer>`
  se neemituje). Bez tohoto JS je editor plně funkční.

## Ověřeno
- `php -l admin/products.php` → bez chyb (PHP 8.3).
- CSP sken: žádné `style=`, `onclick`/`on*=`, `<script>` s kódem ani `<style>` bloky.
- Render edit + new režimu přes stuby: 9 karet, savebar, `editor-links` jen v editu,
  všech 35 editorových polí přítomno, `remove_image` jen když je obrázek, hodnoty
  XSS-safe escapované, `after=stay/close`, `do=save`, `id`, CSRF zachovány.

Náhled: otevři `preview-editor-produktu.html` v prohlížeči (má inlinutý app.css jen
pro náhled — v appce styly zůstávají v `assets/app.css`).
