/* PTI — PIN pad interaction (CSP: served from 'self', no inline JS).
   Progressive: the form also works if the hidden field is filled by a
   physical numeric keyboard. */
(function () {
  'use strict';

  var pad = document.querySelector('[data-pinpad]');
  if (!pad) return;

  var form  = pad.closest('form');
  var field = form.querySelector('input[name="pin"]');
  var dots  = form.querySelectorAll('.pin-dot');
  var maxLen = parseInt(pad.getAttribute('data-maxlen') || '8', 10);

  function render() {
    var n = field.value.length;
    dots.forEach(function (d, i) { d.classList.toggle('on', i < n); });
  }

  function push(digit) {
    if (field.value.length >= maxLen) return;
    field.value += digit;
    render();
  }
  function clearAll() { field.value = ''; render(); }
  function backspace() { field.value = field.value.slice(0, -1); render(); }

  pad.addEventListener('click', function (e) {
    var key = e.target.closest('.pinkey');
    if (!key) return;
    var action = key.getAttribute('data-key');
    if (action === 'clear') { clearAll(); }
    else if (action === 'go') { if (field.value.length >= 4) form.submit(); }
    else if (action === 'back') { backspace(); }
    else { push(action); }
  });

  // physical keyboard support
  document.addEventListener('keydown', function (e) {
    if (e.key >= '0' && e.key <= '9') { push(e.key); }
    else if (e.key === 'Backspace') { e.preventDefault(); backspace(); }
    else if (e.key === 'Enter') { if (field.value.length >= 4) form.submit(); }
    else if (e.key === 'Escape') { clearAll(); }
  });

  render();
})();

/* PTI — pricing matrix 3D tab switching */
(function () {
  'use strict';
  document.querySelectorAll('[data-mtx-tabs]').forEach(function (group) {
    var tabs = group.querySelectorAll('[data-mtx-tab]');
    var panels = document.querySelectorAll('[data-mtx-panel="' + group.getAttribute('data-mtx-tabs') + '"]');
    group.addEventListener('click', function (e) {
      var t = e.target.closest('[data-mtx-tab]');
      if (!t) return;
      var idx = t.getAttribute('data-mtx-tab');
      tabs.forEach(function (x) { x.classList.toggle('on', x === t); });
      panels.forEach(function (p) { p.classList.toggle('on', p.getAttribute('data-mtx-idx') === idx); });
    });
  });
})();

/* PTI — sale builder live customer price (no margin shown to seller) */
(function () {
  'use strict';
  var root = document.querySelector('[data-builder]'); if (!root) return;
  var dataEl = document.getElementById('px-data'); if (!dataEl) return;
  var data; try { data = JSON.parse(dataEl.textContent); } catch (e) { return; }
  var prices = data.prices || {}; var SEP = '\u001f';
  var dimOrder = data.dimOrder || []; var hasQty = !!data.hasQty;
  var discEl = root.querySelector('[data-disc]');
  var maxDisc = parseFloat(root.getAttribute('data-maxdisc') || '0') || 0;
  var addBtns = root.querySelectorAll('[data-add]');
  function setAdd(on) { addBtns.forEach(function (b) { if (on) b.removeAttribute('disabled'); else b.setAttribute('disabled', 'disabled'); }); }
  var outCzk = root.querySelector('[data-out-czk]'), outEur = root.querySelector('[data-out-eur]');
  var outStrike = root.querySelector('[data-strike]'), outUnit = root.querySelector('[data-unit]');
  var qtyEl = root.querySelector('[data-qty]');
  function fmt(n) { return n.toLocaleString('cs-CZ', { maximumFractionDigits: 0 }); }
  function selVal(id) { var g = root.querySelector('[data-dim="' + id + '"]'); if (!g) return undefined; var c = g.querySelector('input:checked'); return c ? c.value : null; }
  function keyFor(qpos) {
    var parts = [];
    for (var i = 0; i < dimOrder.length; i++) {
      var id = dimOrder[i];
      if (qpos && Object.prototype.hasOwnProperty.call(qpos, id)) { parts.push(qpos[id]); }
      else { var v = selVal(id); if (v === null || v === undefined) return null; parts.push(v); }
    }
    return parts.join(SEP);
  }
  function markOn() { root.querySelectorAll('.bld-opt,.vcard').forEach(function (lbl) { var inp = lbl.querySelector('input'); lbl.classList.toggle('on', !!(inp && inp.checked)); }); }
  var qtyFirst = {};
  root.querySelectorAll('.qrow').forEach(function (r) { try { var qp = JSON.parse(r.getAttribute('data-qpos') || '{}'); for (var k in qp) { if (qtyFirst[k] === undefined) qtyFirst[k] = qp[k]; } } catch (e) {} });
  function updateCards() {
    root.querySelectorAll('.vcard').forEach(function (card) {
      var pr = card.querySelector('[data-vprice]'); if (!pr) return;
      var cardGroup = card.closest('[data-dim]'); var vval = card.getAttribute('data-vval');
      var parts = [];
      for (var i = 0; i < dimOrder.length; i++) {
        var id = dimOrder[i]; var g = root.querySelector('[data-dim="' + id + '"]');
        if (g === cardGroup) { parts.push(vval); }
        else if (g) { var c = g.querySelector('input:checked'); if (!c) { parts = null; break; } parts.push(c.value); }
        else { if (qtyFirst[id] === undefined) { parts = null; break; } parts.push(qtyFirst[id]); }
      }
      if (!parts) { pr.textContent = ''; return; }
      var px = prices[parts.join(SEP)];
      pr.innerHTML = px ? (fmt(px.c) + ' Kč' + (px.e != null ? ' <small>/ ' + fmt(px.e) + ' €</small>' : '')) : '—';
    });
  }
  function recompute() {
    markOn(); updateCards();
    var lines = [];
    var d = discEl ? (parseFloat(discEl.value) || 0) : 0; if (d < 0) d = 0; if (d > maxDisc) { d = maxDisc; if (discEl) discEl.value = String(maxDisc); }
    var totalC = 0, totalE = 0, anyE = true, totalQ = 0;
    if (hasQty) {
      root.querySelectorAll('.qrow').forEach(function (r) {
        var qp = {}; try { qp = JSON.parse(r.getAttribute('data-qpos') || '{}'); } catch (e) {}
        var inp = r.querySelector('input[data-qcell]');
        var k = keyFor(qp); var px = k !== null ? prices[k] : undefined;
        var prEl = r.querySelector('[data-qprice]');
        var stepBtns = r.querySelectorAll('[data-qstep]');
        if (!px) {
          // tento typ osoby není ve zvolené variantě nabízen → zákaz + zašednutí
          r.classList.add('qrow--off');
          if (inp) { inp.value = '0'; inp.disabled = true; }
          stepBtns.forEach(function (b) { b.disabled = true; });
          if (prEl) prEl.innerHTML = '<span class="pdx-x" title="V této variantě není nabízeno">\u2715</span>';
          return;
        }
        r.classList.remove('qrow--off');
        if (inp) inp.disabled = false;
        stepBtns.forEach(function (b) { b.disabled = false; });
        var q = Math.max(0, parseInt(inp && inp.value, 10) || 0);
        if (prEl) prEl.innerHTML = fmt(px.c) + ' Kč' + (px.e != null ? ' <small>/ ' + fmt(px.e) + ' €</small>' : '');
        if (q > 0) { totalC += px.c * q; if (px.e != null) totalE += px.e * q; else anyE = false; totalQ += q; lines.push({ l: r.getAttribute('data-label') || '', q: q, c: px.c * q }); }
      });
      if (outUnit) outUnit.textContent = totalQ > 0 ? (totalQ + ' ks') : '';
    } else {
      var q = Math.max(1, parseInt(qtyEl && qtyEl.value, 10) || 1); var k = keyFor(null); var px = k !== null ? prices[k] : undefined;
      if (px) { totalC = px.c * q; totalE = px.e != null ? px.e * q : 0; anyE = px.e != null; totalQ = q; lines.push({ l: 'Vstupenky', q: q, c: px.c * q }); if (outUnit) outUnit.textContent = fmt(px.c) + ' Kč' + (px.e != null ? ' / ' + fmt(px.e) + ' €' : '') + (q > 1 ? ' × ' + q : ''); }
    }
    var addC = 0, addE = 0;
    root.querySelectorAll('[data-addon]').forEach(function (r) {
      var inp = r.querySelector('input[data-qcell]'); var q = Math.max(0, parseInt(inp && inp.value, 10) || 0);
      var ac = parseFloat(r.getAttribute('data-addon-czk')) || 0; var ae = r.getAttribute('data-addon-eur');
      if (q > 0) { addC += ac * q; if (ae !== '' && ae != null) addE += parseFloat(ae) * q; lines.push({ l: r.getAttribute('data-label') || 'Doplněk', q: q, c: ac * q }); }
    });
    var custC = totalC * (1 - d / 100) + addC; var custE = anyE ? (totalE * (1 - d / 100) + addE) : null;
    if (outStrike) outStrike.textContent = (d > 0 && totalQ > 0) ? fmt(totalC + addC) + ' Kč' : '';
    if (outCzk) outCzk.textContent = totalQ > 0 ? fmt(custC) + ' Kč' : '—';
    if (outEur) outEur.textContent = (totalQ > 0 && custE != null) ? fmt(custE) + ' €' : '';
    var sumEl = root.querySelector('[data-summary]');
    if (sumEl) {
      if (lines.length) {
        var esc = function (s) { return String(s).replace(/[&<>]/g, function (c) { return c === '&' ? '&amp;' : c === '<' ? '&lt;' : '&gt;'; }); };
        var html = lines.map(function (L) { return '<div class="pdx-sumrow"><span>' + L.q + '× ' + esc(L.l) + '</span><strong>' + fmt(L.c) + ' Kč</strong></div>'; }).join('');
        if (d > 0) { html += '<div class="pdx-sumrow"><span>Sleva ' + d + ' %</span><strong>-' + d + ' %</strong></div>'; }
        sumEl.innerHTML = html;
      } else { sumEl.innerHTML = '<div class="pdx-hint">Zadejte počet osob.</div>'; }
    }
    var confirmEl = root.querySelector('[data-reserve-confirm]');
    setAdd(totalQ > 0 && (!confirmEl || confirmEl.checked));
  }
  root.addEventListener('change', recompute);
  root.addEventListener('input', recompute);
  root.querySelectorAll('[data-qstep]').forEach(function (b) {
    b.addEventListener('click', function () {
      var t = b.getAttribute('data-qfor');
      var inp = t ? root.querySelector('input[data-qcell="' + t + '"]') : qtyEl;
      if (!inp) return;
      var min = t ? 0 : 1; var q = Math.max(min, parseInt(inp.value, 10) || min);
      q += (b.getAttribute('data-qstep') === '+' ? 1 : -1); if (q < min) q = min;
      inp.value = String(q); recompute();
    });
  });
  recompute();
})();

/* Schedule-driven date/time picker: fill allowed times for the chosen date;
   default to today (or next allowed day for restricted-day products). */
(function () {
  var dataEl = document.getElementById('px-data');
  if (!dataEl) return;
  var data; try { data = JSON.parse(dataEl.textContent); } catch (e) { return; }
  var sched = data && data.schedule;
  if (!sched || !sched.rules || !sched.rules.length) return;
  var dateEl = document.querySelector('[data-sched-date]');
  var sel = document.querySelector('[data-time-select]');
  var hint = document.querySelector('[data-sched-hint]');
  if (!dateEl || !sel) return;

  var lf = data && data.langFilter;
  function selLang() {
    if (!lf) return null;
    var c = document.querySelector('input[name="dim_' + lf.dim + '"]:checked');
    return c ? (lf.map[c.value] || null) : null;
  }

  function iso(dstr) { var d = new Date(dstr + 'T00:00:00'); if (isNaN(d.getTime())) return 0; return ((d.getDay() + 6) % 7) + 1; }
  function allowed(dstr) {
    var wd = iso(dstr), out = {}, i, j, r;
    for (i = 0; i < sched.rules.length; i++) {
      r = sched.rules[i];
      if (r.from || r.to) {
        var md = dstr.slice(5), mf = r.from ? r.from.slice(5) : null, mt = r.to ? r.to.slice(5) : null, inS = true;
        if (mf !== null && mt !== null) { inS = (mf <= mt) ? (md >= mf && md <= mt) : (md >= mf || md <= mt); }
        else if (mf !== null) { inS = md >= mf; }
        else if (mt !== null) { inS = md <= mt; }
        if (!inS) continue;
      }
      if (r.days && r.days.length && r.days.indexOf(wd) === -1) continue;
      for (j = 0; j < (r.times || []).length; j++) out[r.times[j]] = true;
    }
    var keys = Object.keys(out).sort();
    var lc = selLang();
    if (lc) keys = keys.filter(function (t) { return t.indexOf('(' + lc + ')') !== -1; });
    return keys;
  }
  function fill() {
    var prev = sel.value, times = allowed(dateEl.value);
    sel.innerHTML = '';
    if (!times.length) { if (hint) hint.textContent = 'V tento den se nekoná'; return; }
    if (hint) hint.textContent = '';
    times.forEach(function (t) { var o = document.createElement('option'); o.value = t; o.textContent = t; sel.appendChild(o); });
    sel.value = times.indexOf(prev) !== -1 ? prev : times[0];
  }
  if (!dateEl.value) dateEl.value = sched.today;
  if (allowed(dateEl.value).length === 0) {
    var base = new Date(dateEl.value + 'T00:00:00');
    for (var k = 1; k <= 60; k++) {
      var ds = new Date(base.getTime() + k * 86400000).toISOString().slice(0, 10);
      if (allowed(ds).length) { dateEl.value = ds; break; }
    }
  }
  dateEl.addEventListener('change', fill);
  if (lf) { var ls = document.querySelectorAll('input[name="dim_' + lf.dim + '"]'); for (var z = 0; z < ls.length; z++) { ls[z].addEventListener('change', fill); } }
  fill();
})();

/* live fuzzy search over the home product index */
(function () {
  var input = document.querySelector('[data-live-search]');
  var pop   = document.querySelector('[data-search-pop]');
  var dataEl = document.getElementById('search-index');
  if (!input || !pop || !dataEl) return;
  var IDX;
  try { IDX = JSON.parse(dataEl.textContent); } catch (e) { return; }

  function norm(s) { return (s || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase(); }
  function fmt(n) { return n.toLocaleString('cs-CZ', { maximumFractionDigits: 0 }); }
  function esc(s) { var d = document.createElement('div'); d.textContent = s; return d.innerHTML; }

  var rows = [], hi = -1;

  function scoreItem(it, q, toks) {
    var h = it.h, n = norm(it.n), a = norm(it.a);
    for (var i = 0; i < toks.length; i++) { if (h.indexOf(toks[i]) === -1) return -1; }
    var s = 1;
    if (n.indexOf(q) === 0) s += 100; else if (n.indexOf(q) > -1) s += 60;
    if (a.indexOf(q) === 0) s += 30; else if (a.indexOf(q) > -1) s += 18;
    return s;
  }

  function highlight(name, q) {
    var i = norm(name).indexOf(q);
    if (q === '' || i < 0) return esc(name);
    return esc(name.slice(0, i)) + '<mark>' + esc(name.slice(i, i + q.length)) + '</mark>' + esc(name.slice(i + q.length));
  }

  function render(q) {
    var toks = q.split(/\s+/).filter(Boolean), scored = [];
    for (var i = 0; i < IDX.length; i++) { var sc = scoreItem(IDX[i], q, toks); if (sc >= 0) scored.push([sc, IDX[i]]); }
    scored.sort(function (x, y) { return y[0] - x[0] || x[1].n.localeCompare(y[1].n, 'cs'); });
    rows = scored.slice(0, 8).map(function (x) { return x[1]; });
    if (!rows.length) { pop.innerHTML = '<div class="sr-empty">Nic nenalezeno — zkus jiný výraz</div>'; pop.hidden = false; hi = -1; return; }
    var html = '<div class="sr-list">';
    rows.forEach(function (it, i) {
      var price = it.p != null ? '<div class="sr-pb"><span class="sr-pf">od</span><span class="sr-p">' + fmt(it.p) + ' Kč</span></div>' : '';
      var catx = (it.c && it.c[0]) ? '<span class="sep">·</span>' + esc(it.c[0]) : '';
      html += '<div class="sr-row" data-href="/product.php?id=' + it.id + '" data-i="' + i + '">'
            + '<span class="sr-kh">' + (i + 1) + '</span>'
            + '<div class="sr-mn"><div class="sr-name">' + highlight(it.n, q) + '</div>'
            + '<div class="sr-m"><span class="ag-tag">' + esc(it.a) + '</span>' + catx + '</div></div>'
            + price + '</div>';
    });
    html += '</div>';
    pop.innerHTML = html; pop.hidden = false; hi = 0; paint();
  }
  function paint() { var rs = pop.querySelectorAll('.sr-row'); rs.forEach(function (r, i) { r.classList.toggle('hi', i === hi); }); }
  function open(i) { if (rows[i]) window.location = '/product.php?id=' + rows[i].id; }

  input.addEventListener('input', function () {
    var q = norm(input.value.trim());
    if (q.length < 1) { pop.hidden = true; rows = []; return; }
    render(q);
  });
  input.addEventListener('keydown', function (e) {
    if (pop.hidden) return;
    if (e.key === 'ArrowDown') { e.preventDefault(); hi = Math.min(rows.length - 1, hi + 1); paint(); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); hi = Math.max(0, hi - 1); paint(); }
    else if (e.key === 'Enter') { if (hi >= 0 && rows[hi]) { e.preventDefault(); open(hi); } }
    else if (e.key === 'Escape') { pop.hidden = true; }
  });
  pop.addEventListener('click', function (e) {
    var row = e.target.closest('.sr-row');
    if (row) { window.location = row.getAttribute('data-href'); }
  });
  document.addEventListener('click', function (e) {
    if (!pop.contains(e.target) && e.target !== input) { pop.hidden = true; }
  });
})();

/* print button (success / voucher) */
(function () {
  document.querySelectorAll('[data-print]').forEach(function (b) {
    b.addEventListener('click', function () { window.print(); });
  });
})();

/* payment amount toggle (full vs deposit) */
(function () {
  var box = document.querySelector('[data-pay-amount]');
  if (!box) return;
  var paidEl = document.querySelector('[data-paid]');
  var balEl = document.querySelector('[data-balance]');
  var balWrap = document.querySelector('[data-balance-wrap]');
  function apply() {
    var depRadio = box.querySelector('input[value="deposit"]');
    var dep = depRadio && depRadio.checked;
    if (paidEl) paidEl.textContent = dep ? box.getAttribute('data-dep-paid') : box.getAttribute('data-full-paid');
    if (balEl) balEl.textContent = dep ? box.getAttribute('data-dep-bal') : box.getAttribute('data-full-bal');
    if (balWrap) balWrap.classList.toggle('balance-hot', !!dep);
  }
  box.querySelectorAll('input[name="payment_amount"]').forEach(function (r) { r.addEventListener('change', apply); });
  apply();
})();

/* ============================================================
   HOME DASHBOARD — REDESIGN behaviors (appended for mockup)
   All hooks via data-* so this maps 1:1 onto server-rendered PHP.
   ============================================================ */

/* (1) keyboard-first: "/" focuses search, number keys jump to favorites,
   "n" starts a new quick sale, "Esc" clears search. Counter can work
   the whole screen without a mouse. */
(function () {
  'use strict';
  var search = document.querySelector('[data-dash-search]');
  if (!search) return;

  document.addEventListener('keydown', function (e) {
    var tag = (e.target.tagName || '').toLowerCase();
    var typing = tag === 'input' || tag === 'textarea' || tag === 'select';

    // "/" or "s" focuses the search from anywhere (unless already typing)
    if (!typing && (e.key === '/' )) {
      e.preventDefault(); search.focus(); search.select();
      return;
    }
    // Alt+1..9 → open favorite N as a quick sale (works even while typing)
    if (e.altKey && e.key >= '1' && e.key <= '9') {
      var rows = document.querySelectorAll('[data-qsell-row]');
      var idx = parseInt(e.key, 10) - 1;
      if (rows[idx]) { e.preventDefault(); window.location = rows[idx].getAttribute('href'); }
      return;
    }
    // "n" → new quick sale (focus search w/ quick flag)
    if (!typing && (e.key === 'n' || e.key === 'N')) {
      var q = document.querySelector('[data-dash-quick]');
      if (q) { e.preventDefault(); q.click(); }
    }
  });
})();

/* (2) in-progress cart banner: shows only when a sale is open. In the
   real app the server prints data-cart-count; here a tiny demo toggle
   lets you preview both states via data-cart-demo buttons. */
(function () {
  'use strict';
  var banner = document.querySelector('[data-dash-cart]');
  if (!banner) return;
  // demo-only: buttons that simulate "has items" / "empty"
  document.querySelectorAll('[data-cart-demo]').forEach(function (b) {
    b.addEventListener('click', function () {
      var on = b.getAttribute('data-cart-demo') === 'on';
      banner.hidden = !on;
    });
  });
})();

/* (3) quick-sell click feedback: pressing a favorite row navigates to the
   product detail with a ?quick=1 flag (server then preselects 1× Adult
   and jumps straight to the price box). Row is an <a>, so this is purely
   a press affordance — no behavior hijack, keyboard Enter still works. */
(function () {
  'use strict';
  document.querySelectorAll('[data-qsell-row]').forEach(function (row) {
    row.addEventListener('mousedown', function () { row.classList.add('pressed'); });
    row.addEventListener('mouseup', function () { row.classList.remove('pressed'); });
    row.addEventListener('mouseleave', function () { row.classList.remove('pressed'); });
  });
})();

/* (4) bilingual price helper: a small toggle that flips favorite/recent
   price labels between "Kč" and "Kč + €" so the seller can show the
   tourist the € figure without opening the product. data-biling-toggle. */
(function () {
  'use strict';
  var t = document.querySelector('[data-biling-toggle]');
  if (!t) return;
  t.addEventListener('change', function () {
    document.querySelectorAll('[data-eur]').forEach(function (el) {
      el.hidden = !t.checked;
    });
  });
})();

/* "+ Rychlý prodej" button focuses the search (full overlay comes later) */
(function () {
  'use strict';
  var qbtn = document.querySelector('[data-dash-quick]');
  var search = document.querySelector('[data-dash-search]');
  if (!qbtn || !search) return;
  qbtn.addEventListener('click', function () { search.focus(); search.select(); });
})();

/* quick-sale: product.php?quick=1 preselects 1 on the first quantity row and
   scrolls to the price box, so a favorite sells in ~1 click. */
(function () {
  'use strict';
  if (!/[?&]quick=1(?:&|$)/.test(location.search)) return;
  var root = document.querySelector('[data-builder]'); if (!root) return;
  var inp = root.querySelector('.qrow input[data-qcell]') || root.querySelector('[data-qty]');
  if (inp) {
    inp.value = inp.hasAttribute('data-qty') ? String(Math.max(1, parseInt(inp.value, 10) || 1)) : '1';
    inp.dispatchEvent(new Event('input', { bubbles: true }));
  }
  var side = root.querySelector('.pdx-side') || root.querySelector('[data-out-czk]');
  if (side && side.scrollIntoView) { side.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
})();

/* ============================================================
   PTI — app.js doplněk: dirty-stav editoru produktu (volitelné)
   Vlož tento blok do assets/app.js. CSP-safe: žádný inline JS,
   navěšuje se z externího souboru. Bez tohoto JS editor funguje
   normálně — savebar jen nezobrazí živé počítadlo změn.

   Aby se app.js na adminu vůbec načetl, musí View::shell pro admin
   stránky předat ['js' => true] (viz poznámka v changelogu).
   ============================================================ */
(function () {
  'use strict';
  function initProductEditorDirty() {
    var editor = document.getElementById('prod-editor');
    if (!editor) return;
    var form = editor.querySelector('form');
    var info = editor.querySelector('.adm-savebar-info');
    if (!form || !info) return;

    var baseInfo = info.innerHTML;            // původní text (Upravuješ #… / Nový produkt…)
    var fields = form.querySelectorAll('input, select, textarea');
    var initial = new Map();
    var submitting = false;

    function snapshot(el) {
      if (el.type === 'checkbox' || el.type === 'radio') return el.checked ? '1' : '0';
      if (el.type === 'file') return '';      // file inputy neumíme porovnat hodnotou
      return el.value;
    }
    fields.forEach(function (el) {
      if (!el.name) return;
      initial.set(el, snapshot(el));
    });

    function recompute() {
      var dirtyEls = [];
      initial.forEach(function (val, el) {
        if (el.type === 'file') { if (el.files && el.files.length) dirtyEls.push(el); return; }
        if (snapshot(el) !== val) dirtyEls.push(el);
      });
      // zvýrazni karty, kde je změna
      editor.querySelectorAll('.adm-card.is-dirty').forEach(function (c) { c.classList.remove('is-dirty'); });
      dirtyEls.forEach(function (el) {
        var card = el.closest('.adm-card');
        if (card) card.classList.add('is-dirty');
      });
      var n = dirtyEls.length;
      if (n === 0) { info.innerHTML = baseInfo; }
      else {
        var word = (n === 1) ? 'neuložená změna' : (n < 5 ? 'neuložené změny' : 'neuložených změn');
        info.innerHTML = '\u25CF <b>' + n + '</b> ' + word;
      }
    }

    form.addEventListener('input', recompute);
    form.addEventListener('change', recompute);
    form.addEventListener('submit', function () { submitting = true; });

    window.addEventListener('beforeunload', function (ev) {
      if (submitting) return;
      var dirty = false;
      initial.forEach(function (val, el) {
        if (el.type === 'file') { if (el.files && el.files.length) dirty = true; return; }
        if (snapshot(el) !== val) dirty = true;
      });
      if (dirty) { ev.preventDefault(); ev.returnValue = ''; }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initProductEditorDirty);
  } else {
    initProductEditorDirty();
  }
})();

/* ============================================================
   CSP-safe potvrzení: <form data-confirm="…"> přeruší submit,
   pokud uživatel nepotvrdí. Náhrada inline onsubmit="confirm()".
   ============================================================ */
(function () {
  'use strict';
  document.addEventListener('submit', function (e) {
    var f = e.target.closest('form[data-confirm]');
    if (!f) return;
    if (!window.confirm(f.getAttribute('data-confirm') || 'Opravdu pokračovat?')) {
      e.preventDefault();
    }
  });
})();

/* ============================================================
   PTI — Matice cen (admin/matrix.php). Hook: [data-matrix].
   - dirty: zvýrazní změněné buňky + počítá je (savebar/chip)
   - bulk:  [data-mtx-bulk] = pct | round | eur | clear (nad VIDITELNÝMI buňkami)
   - klávesy: ↑/↓/Enter posun mezi Kč poli, Esc zruší fokus
   Pracuje jen s existujícími inputy (name=czk[]/eur[]) a odesílá je
   stávajícím <form>. Nemění datové toky.
   ============================================================ */
(function () {
  'use strict';
  var root = document.querySelector('[data-matrix]');
  if (!root) return;
  var rate = parseFloat(root.getAttribute('data-rate')) || 25;

  var cells = Array.prototype.slice.call(root.querySelectorAll('.mtx-cell'));
  if (!cells.length) return;

  function czkOf(cell) { return cell.querySelector('input[name="czk[]"]'); }
  function eurOf(cell) { return cell.querySelector('input[name="eur[]"]'); }
  function isVisible(cell) {
    var panel = cell.closest('.mtx-panel');
    if (panel && !panel.classList.contains('on')) return false;
    return cell.offsetParent !== null;
  }
  function fmt(n) {
    if (!isFinite(n)) return '';
    var s = (Math.round(n * 100) / 100).toFixed(2);
    return s.replace(/\.00$/, '').replace(/(\.\d)0$/, '$1');
  }
  function parse(v) {
    v = String(v == null ? '' : v).replace(/\s|\u00a0/g, '').replace(',', '.');
    return v === '' || isNaN(parseFloat(v)) ? null : parseFloat(v);
  }

  // snapshot
  var initial = new Map();
  cells.forEach(function (cell) {
    var c = czkOf(cell), e = eurOf(cell);
    initial.set(cell, (c ? c.value : '') + '\u001f' + (e ? e.value : ''));
  });

  var chip = root.querySelector('[data-mtx-count]');
  var savebarInfo = document.querySelector('.adm-savebar-info');
  var baseInfo = savebarInfo ? savebarInfo.innerHTML : '';

  function recount() {
    var n = 0;
    cells.forEach(function (cell) {
      var c = czkOf(cell), e = eurOf(cell);
      var now = (c ? c.value : '') + '\u001f' + (e ? e.value : '');
      var changed = now !== initial.get(cell);
      cell.classList.toggle('is-changed', changed);
      if (changed) n++;
    });
    if (chip) {
      if (n > 0) { chip.hidden = false; chip.textContent = n + (n === 1 ? ' buňka upravena' : (n < 5 ? ' buňky upraveno' : ' buněk upraveno')); }
      else { chip.hidden = true; }
    }
    if (savebarInfo) {
      savebarInfo.innerHTML = n > 0
        ? '\u25CF <b>' + n + '</b> ' + (n === 1 ? 'buňka upravena' : (n < 5 ? 'buňky upraveno' : 'buněk upraveno'))
        : baseInfo;
    }
  }
  root.addEventListener('input', recount);
  root.addEventListener('change', recount);

  // ---- bulk (jen viditelné buňky) ----
  function visibleCells() { return cells.filter(isVisible); }
  function fire(inp) { inp.dispatchEvent(new Event('input', { bubbles: true })); }

  root.querySelectorAll('[data-mtx-bulk]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var act = btn.getAttribute('data-mtx-bulk');
      var vc = visibleCells();
      if (act === 'pct') {
        var p = parseFloat((window.prompt('Změnit Kč i € o kolik %? (např. -10 nebo 5)', '') || '').replace(',', '.'));
        if (isNaN(p)) return;
        vc.forEach(function (cell) {
          var c = czkOf(cell), e = eurOf(cell), cv = parse(c && c.value);
          if (cv != null) c.value = fmt(cv * (1 + p / 100));
          var ev = parse(e && e.value); if (ev != null) e.value = fmt(ev * (1 + p / 100));
        });
      } else if (act === 'round') {
        var step = parseInt(window.prompt('Zaokrouhlit Kč nahoru na násobek? (10 / 50 / 100)', '10') || '0', 10);
        if (!step) return;
        vc.forEach(function (cell) { var c = czkOf(cell), cv = parse(c && c.value); if (cv != null) c.value = fmt(Math.ceil(cv / step) * step); });
      } else if (act === 'eur') {
        vc.forEach(function (cell) {
          var c = czkOf(cell), e = eurOf(cell), cv = parse(c && c.value);
          if (cv != null && e && parse(e.value) == null) e.value = fmt(Math.round(cv / rate));
        });
      } else if (act === 'clear') {
        if (!window.confirm('Vyčistit ' + vc.length + ' viditelných buněk?')) return;
        vc.forEach(function (cell) { var c = czkOf(cell), e = eurOf(cell); if (c) c.value = ''; if (e) e.value = ''; });
      }
      var first = vc[0] && czkOf(vc[0]); if (first) fire(first); else recount();
    });
  });

  // ---- klávesová navigace mezi Kč poli ----
  function czkInputs() { return visibleCells().map(czkOf).filter(Boolean); }
  root.addEventListener('focusin', function (e) {
    if (e.target.matches && e.target.matches('input[name="czk[]"]')) e.target.classList.add('mtx-here');
  });
  root.addEventListener('focusout', function (e) {
    if (e.target.classList) e.target.classList.remove('mtx-here');
  });
  root.addEventListener('keydown', function (e) {
    var t = e.target;
    if (!(t.matches && t.matches('input[name="czk[]"]'))) return;
    if (e.key !== 'ArrowDown' && e.key !== 'ArrowUp' && e.key !== 'Enter') return;
    var list = czkInputs(); var i = list.indexOf(t); if (i === -1) return;
    e.preventDefault();
    var j = (e.key === 'ArrowUp') ? i - 1 : i + 1;
    if (list[j]) { list[j].focus(); list[j].select(); }
  });

  recount();
})();
