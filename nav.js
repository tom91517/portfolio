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
  var onResumePage = /resume\.html$/.test(location.pathname);

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
          '<iframe src="' + RESUME_PDF + '#toolbar=0&navpanes=0&view=FitH" class="resume-embed" title="Jin-Tang Shen Resume">' +
            '<p>Your browser can\'t display the PDF inline. <a href="' + RESUME_PDF + '" download="' + RESUME_PDF_NAME + '">Download it here</a> instead.</p>' +
          '</iframe>' +
        '</div>' +
      '</div>' +
    '</div>';
  document.body.appendChild(overlay);

  var closeBtn = overlay.querySelector('.resume-modal-close');

  function openResumeModal() {
    overlay.classList.add('open');
    document.body.classList.add('resume-modal-lock');
    requestAnimationFrame(function () { overlay.classList.add('show'); });
  }

  function closeResumeModal() {
    overlay.classList.remove('show');
    document.body.classList.remove('resume-modal-lock');
    setTimeout(function () { overlay.classList.remove('open'); }, 200);
  }

  document.addEventListener('click', function (e) {
    var trigger = e.target.closest('a[href="resume.html"]');
    if (trigger) {
      e.preventDefault();
      if (!onResumePage) openResumeModal();
      return;
    }
    if (e.target === overlay) closeResumeModal();
  });

  closeBtn.addEventListener('click', closeResumeModal);

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && overlay.classList.contains('open')) closeResumeModal();
  });
}());
