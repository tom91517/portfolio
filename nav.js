(function () {
  var toggle = document.querySelector('.nav-toggle');
  var nav    = document.querySelector('nav.links');
  if (!toggle || !nav) return;

  toggle.addEventListener('click', function () {
    var open = nav.classList.toggle('open');
    toggle.classList.toggle('open', open);
    toggle.setAttribute('aria-expanded', String(open));
  });

  // Close menu when a link is clicked
  nav.querySelectorAll('a').forEach(function (a) {
    a.addEventListener('click', function () {
      nav.classList.remove('open');
      toggle.classList.remove('open');
      toggle.setAttribute('aria-expanded', 'false');
    });
  });
}());

// Resume: open as a popup instead of navigating to a standalone page
(function () {
  var RESUME_PDF = 'resume.pdf';
  var RESUME_PDF_NAME = 'Jin-Tang Shen - Resume.pdf';
  var PDF_VIEW = '#toolbar=0&navpanes=0&view=FitH';
  // Below this width the CSS hides the embed and shows the fallback card, so
  // there is nothing to load. Keep in sync with the 720px rule in style.css.
  var EMBED_MIN_WIDTH = 721;

  // Netlify's Pretty URLs rewrites resume.html to /resume at deploy time, so
  // compare normalised paths rather than matching the href string.
  function isResumePath(url) {
    try {
      return /\/resume(\.html)?$/.test(new URL(url, location.href).pathname.replace(/\/+$/, ''));
    } catch (err) {
      return false;
    }
  }

  // The standalone resume page already shows the PDF. Building a second hidden
  // viewer there just downloads it twice.
  if (isResumePath(location.href)) return;

  var overlay = document.createElement('div');
  overlay.className = 'resume-modal-overlay';
  overlay.innerHTML =
    '<div class="resume-modal" role="dialog" aria-modal="true" aria-label="Resume">' +
      '<div class="resume-modal-header">' +
        '<a href="' + RESUME_PDF + '" download="' + RESUME_PDF_NAME + '" class="btn btn-primary">Download Resume (PDF) ↓</a>' +
        '<button type="button" class="resume-modal-close" aria-label="Close">&times;</button>' +
      '</div>' +
      '<div class="resume-modal-body">' +
        '<div class="resume-paper">' +
          '<iframe class="resume-embed" tabindex="-1" title="Jin-Tang Shen Resume"></iframe>' +
          '<div class="resume-fallback">' +
            '<p class="resume-fallback-title">The resume reads better full screen.</p>' +
            '<p class="resume-fallback-note">Open the PDF in a new tab to read it at full size.</p>' +
            '<div class="cta-row">' +
              '<a href="' + RESUME_PDF + '" target="_blank" rel="noopener" class="btn btn-primary">Open Resume (PDF) &#8599;</a>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>' +
    '</div>';
  document.body.appendChild(overlay);

  var closeBtn = overlay.querySelector('.resume-modal-close');
  var iframe = overlay.querySelector('.resume-embed');
  var closeTimer = null;
  var lastFocused = null;

  function openResumeModal(trigger) {
    clearTimeout(closeTimer);
    // The PDF is 178KB. Only fetch it when someone actually asks to see it,
    // and only at widths where the embed is visible.
    if (!iframe.getAttribute('src') && window.innerWidth >= EMBED_MIN_WIDTH) {
      iframe.setAttribute('src', RESUME_PDF + PDF_VIEW);
    }
    lastFocused = trigger || document.activeElement;
    overlay.classList.add('open');
    document.body.classList.add('resume-modal-lock');
    requestAnimationFrame(function () {
      overlay.classList.add('show');
      closeBtn.focus();
    });
  }

  function closeResumeModal() {
    if (!overlay.classList.contains('open')) return;
    overlay.classList.remove('show');
    document.body.classList.remove('resume-modal-lock');
    clearTimeout(closeTimer);
    closeTimer = setTimeout(function () { overlay.classList.remove('open'); }, 200);
    if (lastFocused && lastFocused.focus) lastFocused.focus();
    lastFocused = null;
  }

  document.addEventListener('click', function (e) {
    var trigger = e.target.closest('a[href]');
    if (trigger && isResumePath(trigger.getAttribute('href'))) {
      e.preventDefault();
      openResumeModal(trigger);
      return;
    }
    if (e.target === overlay) closeResumeModal();
  });

  closeBtn.addEventListener('click', closeResumeModal);

  document.addEventListener('keydown', function (e) {
    if (!overlay.classList.contains('open')) return;
    if (e.key === 'Escape') {
      closeResumeModal();
      return;
    }
    // Keep Tab inside the dialog so focus cannot wander onto the page behind it.
    if (e.key !== 'Tab') return;
    // The mobile fallback link is display:none on desktop and vice versa.
    // Counting hidden elements makes the wrap fire on the wrong one, and focus
    // falls out of the dialog.
    var items = [].filter.call(
      overlay.querySelectorAll('a[href], button:not([disabled])'),
      function (el) { return el.offsetParent !== null; }
    );
    if (!items.length) return;
    var first = items[0];
    var last = items[items.length - 1];
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    } else if (!overlay.contains(document.activeElement)) {
      e.preventDefault();
      first.focus();
    }
  });
}());