/* Kalvi - small UI helpers (no framework needed) */
(function () {
  'use strict';

  // 1. Bootstrap validation + password match + loading indicator on submit
  document.querySelectorAll('form.needs-validation').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      var pw = form.querySelector('[name=password]'), cp = form.querySelector('[name=confirmPassword]');
      if (pw && cp) cp.setCustomValidity(pw.value === cp.value ? '' : 'Passwords do not match');
      var np = form.querySelector('[name=newPassword]'), nc = form.querySelector('[name=confirmPassword]');
      if (np && nc) nc.setCustomValidity(np.value === nc.value ? '' : 'Passwords do not match');
      if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
      else { var l = document.getElementById('loading'); if (l) l.classList.add('show'); }
      form.classList.add('was-validated');
    });
  });

  // 2. Confirmation dialogs: <form data-confirm="Delete this item?">
  document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (e) { if (!window.confirm(form.getAttribute('data-confirm'))) e.preventDefault(); });
  });

  // 3. Print buttons: <button data-print>
  document.querySelectorAll('[data-print]').forEach(function (b) { b.addEventListener('click', function () { window.print(); }); });

  // 4. Show the loading spinner for normal link navigation inside the app
  window.addEventListener('pageshow', function () { var l = document.getElementById('loading'); if (l) l.classList.remove('show'); });

  // 5. Auto-hide success alerts
  setTimeout(function () { document.querySelectorAll('.alert-success').forEach(function (a) { if (window.bootstrap) bootstrap.Alert.getOrCreateInstance(a).close(); }); }, 6000);
})();
