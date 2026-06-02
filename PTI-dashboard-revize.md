# PTI Home Dashboard — UX/UI revize, doporučení a nápady

> Doprovodný dokument k mockupu `dashboard-redesign.html`. Vychází z reálného stavu přiložených souborů (`current-dashboard.html`, `current-grid.html`, `app.css`, `app.js`) a z předělaného detailu produktu (`product-detail-redesigned.html`), jehož vizuální jazyk přebírám.

Pohled, ze kterého celý dokument píšu: **prodejce stojí, u pultu je turista, často fronta, a každá sekunda i každé zaváhání se počítá.** Vše níž poměřuju jediným měřítkem — *zrychluje to cestu „turista něco chce → vytištěný voucher", nebo ne?*

---

## 1. UX/UI kritika současného stavu

Procházím po jednotlivých prvcích tak, jak je prodejce vidí shora dolů.

**Vyhledávací lišta (✅ živá, nejsilnější prvek na stránce).**
Funguje výborně — našeptávač je rychlý, diakritika-necitlivý, aliasy CZ/EN/DE sedí (`lod` → cruise/boat), klávesy fungují. Tohle je srdce a je dobré. Drobnosti, které brzdí:
- Lišta nemá vizuální „váhu" odpovídající tomu, že je to hlavní vstup. Tlačítko „Hledat" vedle ní je zbytečné — našeptávač řeší výběr dřív, než by někdo klikl na „Hledat". Prodejce u pultu nechce dvě cesty k témuž.
- Není vidět, že stačí psát a ono to hledá. Chybí drobná nápověda (ikona lupy, zkratka).
- Duplicitní produkty (3× Terezín, 4× Karlovy Vary, několik Český Krumlov) se v našeptávači liší jen agenturou a cenou — prodejce je musí rozlišit očima. To je riziko špatného kliknutí.

**Horní pruh se statistikami (🟡 placeholder).**
Dnes ukazuje „—" a poznámku „ožije po prvních prodejích". Zabírá prémiové místo hned pod hledáním a nedává nic. Buď to musí nést hodnotu (viz §2), nebo to nemá být tak vysoko. Navíc tam chybí to, co prodejce u pultu reálně potřebuje na konci dne (hotově vs. kartou, počet rezervací k vyřízení).

**Tlačítko „+ Rychlý prodej" (🟡 zašedlé, „Připravujeme").**
Mrtvé tlačítko na nejdůležitější obrazovce kazí důvěru — prodejce nakliká „nefunguje to" a přestane zkoušet. Buď zprovoznit, nebo skrýt.

**Dlaždice kategorií (✅ živé).**
Vizuálně pěkné, barevné, s počty. Fungují. Jediné: na desktopu u pultu zabírají hodně svislého místa a tlačí oblíbené/ostatní pod ohyb. Procházení kategorií je sekundární cesta (primární je hledání) — můžou být hutnější.

**Tagy agentur (✅ živé).**
Dobré, kompaktní, čitelné. Bez výhrad — jen je otázka, jestli „1 produkt" agentura (Big Bus, Folklore Garden, WOW Show…) potřebuje vlastní filtr, nebo spíš patří do našeptávače. Není to chyba, jen šum.

**Tři sloupce dole: Oblíbené / Nejprodávanější / Nedávno prodané (✅ + 🟡 + 🟡).**
- *Oblíbené* je živé a užitečné, ale je to jen **odkaz na detail** — prodejce klikne, dostane se na konfiguraci, tam teprve prodává. U „nejčastějších" položek je to o klik víc, než by muselo být.
- *Nejprodávanější* a *Nedávno prodané* jsou prázdné placeholdery se stejným textem. Dva identické „Ožije po prvních prodejích" vedle sebe působí jako rozbitá stránka, ne jako „čekáme na data".
- Tři stejně velké sloupce dávají oblíbeným (živým) stejnou váhu jako dvěma prázdným. Hierarchie neodpovídá hodnotě.

**Co chybí na první pohled (⛔).**
- **Není vidět rozdělaný prodej.** Když prodejce odběhne, vrátí se a netuší, jestli má něco v košíku. To je u pultu pod tlakem reálné riziko (dvojí prodej, ztracený rozpracovaný nákup).
- **Není cesta ke správě prodejů** (storno/refundace/reprint) — existuje na jiné obrazovce, ale z home se tam nedostanete. Turista se vrací „ztratil jsem voucher" a prodejce neví, kudy.
- **Není připomínka „rezervace nutná".** Produkt vyžaduje rezervaci u agentury *před* vystavením voucheru. Pokud na to prodejce zapomene, vystaví neplatný doklad. Na home na to nic neupozorní.
- **Není nic ke konci směny** (souhrn, hotově/kartou, předání).

**Shrnutí kritiky jednou větou:** obrazovka skvěle *hledá*, ale neukazuje *stav* (košík, rezervace, směna) a nedotahuje *nejčastější prodej* na nejméně kliků.

---

## 2. Prioritizovaná doporučení (stávající prvky)

Značím **MUST** (udělat hned) / **NICE** (brzy) / **LATER** (až bude čas). U každého krátké *proč*.

### MUST-HAVE

**M1. Zprovoznit nebo skrýt „+ Rychlý prodej".**
*Proč:* mrtvé tlačítko na srdci systému učí prodejce, že věci nefungují. V mockupu je živé a vede do rychlého prodeje (viz §3, R1).

**M2. Sloučit „Hledat" do našeptávače, lišta jako jediný hero prvek.**
*Proč:* dvě cesty k jednomu cíli zpomalují. Našeptávač už výběr řeší; tlačítko „Hledat" jen mate. Zvětšit lištu, přidat lupu + zkratku `/`.

**M3. Indikátor rozjetého košíku přímo na home (banner pod hledáním).**
*Proč:* nejčastější „ztráta" u pultu je zapomenutý rozdělaný prodej. Banner se ukáže jen když je co ukázat (`hidden` jinak), nese počet položek, částku, a varování pokud je v košíku „rezervace nutná". Dvě akce: *Pokračovat* / *K platbě*.

**M4. Oblíbené → prodej na 1–2 kliky, ne jen odkaz na detail.**
*Proč:* „nejčastější" položky má smysl prodat bez konfigurace. Řádek oblíbené → otevře detail s předvybraným `1× Adult` a skočí rovnou na cenový box (`?quick=1`). U pultu to ušetří 2–3 kroky desetkrát denně.

**M5. Rozlišit duplicitní produkty v našeptávači.**
*Proč:* 3× Terezín / 4× Karlovy Vary se liší jen agenturou a cenou. Agentura už v řádku je (zlatý tag) — stačí ji vizuálně posílit a u shodných názvů přidat odlišovač (cena „od" + agentura jako primární rozlišení). Bez toho hrozí špatné kliknutí.

### NICE-TO-HAVE

**N1. Horní pruh přetavit na „směnový" proužek s reálnou hodnotou.**
*Proč:* místo dvou „—" ukázat to, co prodejce na konci dne potřebuje: prodejů dnes, tržba, **hotově / kartou**, **kolik rezervací čeká na vyřízení**. Dokud nejsou data, jednotlivé buňky můžou být tlumené, ale struktura ať drží.

**N2. „Rezervace nutná" připomínkový rail.**
*Proč:* produkty z dnešních prodejů/košíku, které ještě čekají na zavolání agentuře. Teplé (warn) barvy, číslo voucheru, termín. Prodejce nezapomene zarezervovat dřív, než turista odejde s voucherem.

**N3. Hierarchie tří sloupců podle hodnoty.**
*Proč:* oblíbené (živé, prodejní) nahoru a větší; nejprodávanější a nedávno prodané jako kompaktnější raily. Dva prázdné identické sloupce zrušit — sloučit do jednoho stavu „naplní se během dne".

**N4. Dvojjazyčné zobrazení ceny pro turistu (přepínač „Ceny i v €").**
*Proč:* prodejce mluví česky, turista anglicky/německy. Přepínač v hlavičce doplní u oblíbených/nedávných k „Kč" i „≈ €", aby prodejce mohl ukázat částku turistovi bez otevírání produktu. (Pozn.: € jako orientační „≈", ne závazná cena — viz §3, R5.)

**N5. Dveře ke správě prodejů + reprintu rovnou z home.**
*Proč:* storno/refundace/reprint existují jinde, ale turista se vrací k *tomuhle* pultu. Malý rail „Správa prodejů → najít prodej/voucher" + nedávno prodané s tlačítkem *reprint*.

### LATER

**L1. Zhutnit dlaždice kategorií.**
*Proč:* procházení je sekundární cesta; ať netlačí prodejní raily pod ohyb. Menší dlaždice, případně přepínač „mřížka / seznam".

**L2. Zvážit skrytí filtru pro „1 produkt" agentury.**
*Proč:* agentura s jediným produktem nepotřebuje vlastní filtr — najde se hledáním. Méně šumu v řadě agentur. (Nízká priorita, není to chyba.)

---

## 3. Nové nápady

Rozdělené do dvou rovin, jak jsi chtěl.

### ROVINA 1 — realizovatelné teď (drží se §5, server-rendered PHP, CSP, existující komponenty)

Tyhle jsou v mockupu reálně postavené nebo přímo navazují na existující `data-*` chování.

**R1. Rychlý prodej (1–2 kliky).**
Tlačítko „+ Rychlý prodej" otevře malý overlay/stránku s našeptávačem zaměřeným na prodej: vybereš produkt → předvyplní `1× Adult` → rovnou cenový box „Prodat hned / Přidat do košíku". Oblíbené řádky dělají totéž přes `?quick=1`.
*Proč:* většina prodejů jsou 2–3 produkty pořád dokola; konfigurace je pro ně overkill.

**R2. Banner rozjetého prodeje (M3).**
Hotovo v mockupu: `data-dash-cart`, `[hidden]` když je prázdný, server jen přepne. Nese počet, částku, varování „×N čeká na rezervaci".

**R3. Připomínka rezervací (N2) + barevné odlišení „rezervace nutná" napříč.**
Detail i grid už mají `pbadge-wait` (hodinky, warn) vs. `pbadge-go` (fajfka, ok). V mockletu používám stejnou logiku jako malý `fdot` v railech. Rezervační rail svítí warn barvou — prodejce ji nepřehlédne.
*Proč:* sjednocený vizuální signál „tohle musíš nejdřív zarezervovat" od katalogu po home.

**R4. Klávesová obsluha bez myši.**
V mockupu: `/` fokusne hledání, `↑↓` + `Enter` v našeptávači (už existuje), `Alt+1…9` prodá N-tou oblíbenou, `n` spustí rychlý prodej. Patička s nápovědou kláves.
*Proč:* nejrychlejší prodejci u pultu nesahají na myš. Tohle je čistě klávesnice → voucher.

**R5. Produkty bez ceny / sezónní — explicitní stav, ne prázdno.**
V datech reálně: `p: null` u Airport Transfer, Christmas Dinner, NYE Gala, Private Tours, Pilsner Urquell, Story of Prague. Grid už ukazuje „cena nenastavena". Doporučení: stejný stav i v oblíbených/našeptávači (`qsell-price.noprice`, warn barva), a u sezónních (Christmas/NYE/zimní túry) štítek „sezónní — cena dle termínu". Rychlý prodej takový produkt nenabídne jako „1 klik", ale pošle na konfiguraci.
*Proč:* prodejce nesmí slíbit cenu, která není nastavená; raději jasný signál než `0 Kč`.

**R6. Dvojjazyčný přepínač cen (N4).**
`data-biling-toggle` přepne `data-eur` viditelnost u railů. € jako „≈" orientační.
*Proč:* ukázat turistovi částku bez kontextu Kč, bez odklikávání.

**R7. Konec směny z home.**
Tlačítko „Konec směny →" ve směnovém proužku → souhrn dne (tržba, hotově/kartou, počet prodejů, otevřené rezervace) jako podklad k předání/vyúčtování.
*Proč:* uzavření dne je reálná operace, dnes na home chybí úplně.

**R8. Reprint voucheru z „Nedávno prodané".**
Každý řádek nedávného prodeje má akci *reprint* → znovu vytiskne voucher.
*Proč:* turista mačká „spadlo mi to / chci kopii" — nejčastější poprodejní úkon.

### ROVINA 2 — odvážnější vize (nad rámec zadání; dává smysl, ale chce víc práce / data / rozmyslu)

Tady jdu dál. Některé potřebují data, která teď nejsou, nebo zásah do back-endu. Ber jako směr, ne jako „udělej zítra".

**V1. Kontextový „balíček dne".**
Když turista koupí Big Bus, systém u pultu napoví „lidé k tomu často berou Vltava cruise" (z dat nejprodávanějších kombinací). Prodejce nabídne jedním klikem → vyšší průměrný košík bez tlaku.
*Proč:* cross-sell, který sedí přirozeně do toku prodeje, ne jako reklama.

**V2. Chytrý našeptávač podle počasí / denní doby / sezóny.**
Prší? Nahoru vyplavou krytá divadla, muzea, indoor aktivity. Večer? Dinner cruises a koncerty. Léto vs. zima mění pořadí (lyžování vs. plavby). Data o sezónnosti v katalogu reálně jsou (zimní túry, vánoční večeře).
*Proč:* prodejce je rychlejší, když mu obrazovka napoví relevantní nabídku dřív, než turista doformuluje přání.

**V3. Turistický „náhledový" mód na druhé obrazovce.**
Pult u recepce často má druhý displej k turistovi. Mód, který ukáže turistovi jen fotku, název, € cenu a „co je v ceně" — bez interních věcí. Prodejce řídí ze své obrazovky.
*Proč:* turista vidí, co kupuje, ve své řeči; prodejce neotáčí monitor.

**V4. Hlasový / rychlý vstup destinace.**
Turista řekne „Krumlov tomorrow, two people" — prodejce napíše `krumlov 2 zitra` a systém nabídne varianty Český Krumlov napříč agenturami s cenou a nejbližším termínem, seřazené podle dostupnosti.
*Proč:* řeší duplicity (4× Krumlov) za prodejce a rovnou filtruje na to, co jde dnes prodat.

**V5. „Live" dostupnost u rezervačních produktů.**
U „rezervace nutná" produktů ukázat orientačně, jestli je na zítřek místo (kde to agentura přes API/web dává). Aspoň semafor „nejspíš volno / nejistota / radši zavolej".
*Proč:* prodejce nemusí volat naslepo; míň trapných „počkejte, ověřím".

**V6. Konec směny jako vyúčtování s kontrolou pokladny.**
Souhrn dne + „v pokladně má být X Kč hotově" + pole pro reálný stav → rozdíl. Předávací protokol PDF.
*Proč:* z home se stane i provozní nástroj, ne jen prodejní rozcestník.

**V7. Personalizace home podle prodejce.**
Karel prodává hodně plaveb, Jana koncerty. Oblíbené a pořadí kategorií se učí z vlastní historie. Multi-tenant už máš, tohle je vrstva „per seller".
*Proč:* každý pult má jiný mix; ať obrazovka sedne konkrétnímu člověku.

---

## 4. Klíčová rozhodnutí a proč (pro vývojáře)

- **Search jako jediný hero, košík hned pod ním.** Hledání je primární cesta, stav prodeje je druhá nejdůležitější věc. Vše ostatní (kategorie, agentury) je sekundární a jde níž / doprava.
- **Levý sloupec = procházení, pravý sloupec = prodej a stav.** Oko jde zleva (objevuj) doprava (prodej/akce). Pravý rail je `sticky`, takže oblíbené a rezervace jsou pořád po ruce při scrollování katalogu.
- **Všechno chování přes `data-*`, žádný inline JS/CSS.** Mockup drží CSP striktně (ověřeno — 0 inline stylů, JS jen v `app.js`). Banner košíku je `[hidden]` přepínaný serverem; raily jsou statické `<a>`; klávesy a přepínače jsou delegované listenery. 1:1 přepis do PHP.
- **Žádná marže/provize nikde.** V railech i mocku se ukazuje výhradně cena pro zákazníka.
- **Sjednocený signál „rezervace nutná".** Stejná logika (warn/ok) od `pbadge` v katalogu po `fdot` a rezervační rail na home — prodejce se učí jeden vizuální jazyk.
- **Stavy „bez ceny" a „sezónní" jsou explicitní**, ne `0 Kč`. Rychlý prodej je u nich vypnutý a posílá na konfiguraci.

---

## 5. Co je v mockupu hotové k proklikání

`dashboard-redesign.html` + rozšířené `assets/app.css` a `assets/app.js`:
- živý našeptávač (zachovaný, funguje s `lod`/`castle`/`Schiff`),
- hero hledání se zkratkou `/`,
- banner rozjetého prodeje (náhled obou stavů tlačítky „rozdělaný / prázdný"),
- směnový proužek s tržbou, hotově/kartou, počtem rezervací, „Konec směny",
- oblíbené jako rychlý prodej (`?quick=1`, `Alt+1…9`),
- rezervační připomínky, nejprodávanější, nedávno prodané s reprintem, vstup do správy prodejů,
- přepínač „Ceny i v €",
- responsivní chování pro půl obrazovky (ověřeno na 680 px).

Vše se opírá o existující tokeny a komponenty — žádná nová závislost, žádný build krok.
