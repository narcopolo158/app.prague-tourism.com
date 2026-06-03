# PTI — UI/UX dodávka #3: Pricing matrix editor (priorita č. 2 — „srdce adminu")

Zadání §6.6. Bez zásahu do logiky, názvů polí, datových toků, CSRF a snapshot/verzovací logiky.

## Změněné soubory (overlay)
- `admin/matrix.php` — vlastní mřížka cen: obal do `.adm-card`, informativní hlavička
  (verze · stav · počet buněk / vyplněno), **bulk toolbar**, hook `data-matrix data-rate="25"`,
  **tmavý sticky `.adm-savebar`** (Uložit primary + Zpět + živý počet změn). Generování mřížky
  (0D/1D/2D/3D/4D+) beze změny — jen znovu zabaleno.
- `admin/pricing.php` — workspace dvousloupcově (`.pric-grid`): vlevo **dimenze** v kartách
  + formulář dimenze v kartě; vpravo **sidebar verzí** (`.ver-row` karty: stav draft/aktivní/archiv,
  inline override provize/bonus, „Upravit ceny →" do matice, změna stavu) + „Nová verze" v kartě.
  **Oprava CSP:** inline `onsubmit="return confirm(...)"` → `data-confirm` (řeší modul v app.js).
- `assets/app.js` — přidány 2 guardované moduly (vzor jako stávající):
  1. `form[data-confirm]` → CSP-safe potvrzení místo inline onsubmit,
  2. `[data-matrix]` → dirty (zvýraznění + počet změněných buněk), **bulk** (± %, zaokrouhlit ↑,
     € z kurzu do prázdných, vyčistit viditelné — respektuje aktivní tab u 3D), **klávesy** ↑/↓/Enter
     mezi Kč poli. Vše jen nad existujícími `name=czk[]/eur[]`, odesílá stávající `<form>`.
- `assets/app.css` — přidán blok: `.pric-grid`, `.adm-rside`, `.pric-formula`, `.ver-row*`,
  `.mtx-toolbar`/`.mtx-btn`, `.mtx-cell.is-changed`, sticky `.mtx thead`, `.adm-card-h-r`.
  Staví na `.adm-card`/`.adm-savebar`/`.mtx*`/tokenech; nepřepisuje stávající.
- `app/View.php` — `shell()` **automaticky zapne app.js pro admin** (`subtitle==='administrace'`),
  pokud `js` není explicitně nastaveno. Moduly v app.js jsou guardované IIFE → bez svých
  `data-` hooků jsou no-op, takže je bezpečné je načíst všude. (Rozjede to i dirty-counter
  editoru produktu z dodávky #1 — už není potřeba nic ručně zapínat.)

## Bulk operace (matrix) — bezpečné, jen klient
- **± %** zadáš v promptu (např. -10) → škáluje Kč i € u viditelných buněk.
- **Zaokrouhlit ↑** na násobek 10/50/100 (Kč).
- **€ z kurzu (25)** → dopočítá € jen u prázdných € buněk (manuální override nepřepíše).
- **Vyčistit viditelné** (s potvrzením).
Vše jen předvyplní existující inputy; uloží se přes nezměněný `save_prices` endpoint po review.

## Ověřeno
- `php -l` na pricing.php, matrix.php, View.php → bez chyb (PHP 8.3 + mbstring).
- `node --check app.js` → OK. CSP sweep: žádné `style=`/`on*=`/`<script>`/`<style>` (jediná
  shoda „onsubmit" je v komentáři app.js, ne v kódu).
- Render end-to-end přes stub bootstrap: matice **0D** (1 buňka, toolbar skryt), **1D** (8),
  **2D** (24), **3D** (8 tabů × 6 = 48 polí, `data-mtx-tabs`/`-panel`). Pricing: dvousloupec,
  3 verze (aktivní/draft/archiv) s odkazy na matici, `data-confirm` na mazání dimenzí, app.js
  i patička s uživatelem na obou stranách.

Náhledy (inlinutý CSS+JS jen pro náhled — taby/bulk/dirty fungují v prohlížeči):
`preview-pricing-matrix.html` (3D matice) a `preview-pricing-workspace.html`.
