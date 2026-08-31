(function () {
  var erdTrigger = document.querySelector('.case-erd-trigger');
  var erdDialog = document.querySelector('.case-erd-dialog');
  var erdClose = document.querySelector('.case-erd-dialog-close');
  var mobileQuery = window.matchMedia('(max-width: 700px)');
  var lastFocused = null;

  if (erdTrigger && erdDialog && erdClose && typeof erdDialog.showModal === 'function') {
    erdTrigger.addEventListener('click', function (event) {
      if (!mobileQuery.matches) return;
      event.preventDefault();
      lastFocused = erdTrigger;
      erdDialog.showModal();
      document.body.classList.add('case-erd-dialog-lock');
      erdClose.focus();
    });

    erdClose.addEventListener('click', function () {
      erdDialog.close();
    });

    erdDialog.addEventListener('click', function (event) {
      if (event.target === erdDialog) erdDialog.close();
    });

    erdDialog.addEventListener('close', function () {
      document.body.classList.remove('case-erd-dialog-lock');
      if (lastFocused) lastFocused.focus();
      lastFocused = null;
    });

    const handleMobileChange = function (event) {
      if (!event.matches && erdDialog.open) erdDialog.close();
    };

    if (typeof mobileQuery.addEventListener === 'function') {
      mobileQuery.addEventListener('change', handleMobileChange);
    } else {
      mobileQuery.addListener(handleMobileChange);
    }
  }

  var codeBlocks = [].slice.call(document.querySelectorAll('.case-code-card pre'));

  function updateCodeOverflow(pre) {
    var card = pre.closest('.case-code-card');
    if (!card) return;
    var isScrollable = pre.scrollWidth > pre.clientWidth + 1;
    var isAtEnd = !isScrollable || pre.scrollLeft + pre.clientWidth >= pre.scrollWidth - 2;
    card.classList.toggle('is-scrollable', isScrollable);
    card.classList.toggle('is-scrolled-end', isAtEnd);
  }

  function updateAllCodeBlocks() {
    codeBlocks.forEach(updateCodeOverflow);
  }

  codeBlocks.forEach(function (pre) {
    pre.addEventListener('scroll', function () { updateCodeOverflow(pre); }, { passive: true });
  });

  window.addEventListener('resize', updateAllCodeBlocks);
  requestAnimationFrame(updateAllCodeBlocks);
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(updateAllCodeBlocks);
}());
