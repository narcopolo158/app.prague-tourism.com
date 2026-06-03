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
