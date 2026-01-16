document.addEventListener('DOMContentLoaded', function() {
  const toc = document.getElementById('toc');
  const trigger = document.querySelector('.toc-trigger');
  
  if (!toc) return;
  
  const TRIGGER_ZONE = 40; // pixels from left edge to trigger
  const HIDE_DELAY = 300; // ms delay before hiding
  
  let isVisible = false;
  let hideTimeout = null;
  
  function showToc() {
    if (hideTimeout) {
      clearTimeout(hideTimeout);
      hideTimeout = null;
    }
    if (!isVisible) {
      toc.classList.add('visible');
      isVisible = true;
    }
  }
  
  function hideToc() {
    if (isVisible) {
      hideTimeout = setTimeout(function() {
        toc.classList.remove('visible');
        isVisible = false;
      }, HIDE_DELAY);
    }
  }
  
  // Show TOC when mouse enters trigger zone
  document.addEventListener('mousemove', function(e) {
    if (e.clientX <= TRIGGER_ZONE) {
      showToc();
    }
  });
  
  // Keep TOC visible while mouse is over it
  toc.addEventListener('mouseenter', showToc);
  
  // Hide TOC when mouse leaves it
  toc.addEventListener('mouseleave', function(e) {
    // Only hide if mouse isn't in the trigger zone
    if (e.clientX > TRIGGER_ZONE) {
      hideToc();
    }
  });
  
  // Also hide when clicking outside
  document.addEventListener('click', function(e) {
    if (isVisible && !toc.contains(e.target)) {
      toc.classList.remove('visible');
      isVisible = false;
    }
  });
  
  // Keyboard accessibility: Escape to close
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && isVisible) {
      toc.classList.remove('visible');
      isVisible = false;
    }
  });
  
  // Touch support for mobile
  let touchStartX = 0;
  document.addEventListener('touchstart', function(e) {
    touchStartX = e.touches[0].clientX;
  });
  
  document.addEventListener('touchmove', function(e) {
    const touchX = e.touches[0].clientX;
    const deltaX = touchX - touchStartX;
    
    // Swipe right from left edge to open
    if (touchStartX < 30 && deltaX > 50) {
      showToc();
    }
    // Swipe left to close
    if (isVisible && deltaX < -50) {
      toc.classList.remove('visible');
      isVisible = false;
    }
  });
});
