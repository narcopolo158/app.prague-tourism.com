# PTI — UI/UX dodávka #2: Admin chrome (boční panel)

Priorita č. 3 (§6 / §7). Zadání chtělo boční panel „doladit": ikony, badge
s počty, aktivní stav, patička s uživatelem. **Bez zásahu do logiky/datových toků.**
(Prioritu č. 2 — pricing matrix — zatím nelze: chybí `pricing.php`, `matrix.php`, `app.js`.)

## Změněné soubory (overlay)
- `app/View.php` — přestavěn `View::adminNav()`:
  - **nová privátní `View::navIcon()`** — inline SVG ikony (stroke=currentColor, žádný style=),
  - **zpětně kompatibilní signatura** `adminNav(string $active, array $opts = [])`;
    `$opts['actor']` → patička s uživatelem, `$opts['badges']` → počty u položek.
    Stávající volání s jedním argumentem fungují beze změny.
- `assets/app.css` — přidán blok: `.adm-side-link` (flex řádek), `.adm-side-ic`,
  `.adm-side-tx`, `.adm-side-badge`, `.adm-side-foot*`. Nepřepisuje stávající `.adm-side*`.
- `admin/products.php` — **jediná řádka navíc**: volání `View::adminNav('products', ['actor'=>$a])`
  (proměnná `$a` už byla v scope; žádný nový dotaz). Patička pak ukáže přihlášeného admina.

## Co se vizuálně mění
- Každá položka má ikonu (Přehled, Produkty, Pořadí, Kategorie, Agentury, Rozvrhy,
  Prodejci, Reporty, Admini). Ikona dědí barvu odkazu: tlumená → bílá na hover →
  **zlatá na aktivní položce**.
- Volitelné počty (badge) — jemný tmavý pill, na aktivní položce zlatý. Nula se skryje.
- Patička dole se zlatým avatarem, jménem a rolí (mono, uppercase).

## Jak zapnout počty (volitelné, bezpečné)
`adminNav` přijímá `['badges' => ['products'=>141, 'agencies'=>21, ...]]`.
Každá admin stránka může předat čísla, která už stejně počítá. Příklad pro Produkty:
`View::adminNav('products', ['actor'=>$a, 'badges'=>['products'=>count($list)]])`.
Bez předání badges se nic nevykreslí (žádná regrese).

## Ověřeno
- `php -l` na View.php i products.php → bez chyb (PHP 8.3 + mbstring jako v produkci).
- CSP sweep napříč všemi soubory: žádné `style=`, `on*=`, `<script>`/`<style>`.
- Funkční test `adminNav`: 1-arg režim = beze změny (bez patičky), 9 ikon, aktivní stav;
  s `actor`+`badges` = patička, počty 141/21 vykresleny, nula potlačena, žádný `style=`.

Náhled: `preview-admin-chrome.html` (boční panel + nový editor pohromadě).
