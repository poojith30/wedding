/**
 * 24 Hours, Two Religions, One Love — A Hyderabadi Wedding Story
 * Interactive Editorial Controller — Refined & Accessible
 */

document.addEventListener('DOMContentLoaded', () => {
  initReadingProgress();
  initNavScrollState();
  initChapterObserver();
  initTimelineActiveTracker();
  initLightbox();
  initBackToTop();
  initImageErrorFallbacks();
});

/**
 * 1. Top Reading Progress Indicator
 */
function initReadingProgress() {
  const progressBar = document.getElementById('reading-progress');
  if (!progressBar) return;

  function updateProgress() {
    const totalHeight = document.documentElement.scrollHeight - window.innerHeight;
    if (totalHeight <= 0) return;
    const progress = Math.min(100, Math.max(0, (window.scrollY / totalHeight) * 100));
    progressBar.style.width = `${progress}%`;
    progressBar.setAttribute('aria-valuenow', Math.round(progress));
  }

  window.addEventListener('scroll', updateProgress, { passive: true });
  window.addEventListener('resize', updateProgress, { passive: true });
  updateProgress();
}

/**
 * 2. Sticky Nav Scroll State
 */
function initNavScrollState() {
  const nav = document.getElementById('main-nav');
  if (!nav) return;

  function onScroll() {
    if (window.scrollY > 30) {
      nav.classList.add('nav-scrolled');
    } else {
      nav.classList.remove('nav-scrolled');
    }
  }

  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
}

/**
 * 3. Intersection Observer for Gentle Fade-and-Rise Reveals
 */
function initChapterObserver() {
  const sections = document.querySelectorAll('.chapter-section');
  if (!('IntersectionObserver' in window)) {
    sections.forEach((sec) => sec.classList.add('is-revealed'));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-revealed');
          observer.unobserve(entry.target);
        }
      });
    },
    {
      root: null,
      rootMargin: '0px 0px -6% 0px',
      threshold: 0.08,
    }
  );

  sections.forEach((sec) => observer.observe(sec));
}

/**
 * 4. Timeline Active Node Tracker
 */
function initTimelineActiveTracker() {
  const chapters = document.querySelectorAll('.chapter-section[id]');
  const timelineNodes = document.querySelectorAll('.timeline-node[data-target]');
  const timelineContainer = document.querySelector('.timeline-container');
  const indicator = document.getElementById('nav-chapter-indicator');

  if (!chapters.length || !timelineNodes.length) return;

  const nodeMap = new Map();
  timelineNodes.forEach((node) => {
    nodeMap.set(node.getAttribute('data-target'), node);

    // Immediate active feedback on click
    node.addEventListener('click', () => {
      timelineNodes.forEach((n) => n.classList.remove('is-active'));
      node.classList.add('is-active');
    });
  });

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const id = entry.target.id;
          timelineNodes.forEach((node) => node.classList.remove('is-active'));
          const activeNode = nodeMap.get(id);
          if (activeNode) {
            activeNode.classList.add('is-active');
            
            // Auto-center active node within scrollable timeline on smaller viewports
            if (timelineContainer) {
              const nodeLeft = activeNode.offsetLeft;
              const nodeWidth = activeNode.offsetWidth;
              const containerWidth = timelineContainer.clientWidth;
              timelineContainer.scrollTo({
                left: nodeLeft - (containerWidth / 2) + (nodeWidth / 2),
                behavior: 'smooth'
              });
            }

            // Update nav chapter indicator
            if (indicator) {
              const time = activeNode.querySelector('.timeline-time')?.textContent || '';
              const title = activeNode.querySelector('.timeline-title')?.textContent || '';
              if (time && title) {
                indicator.textContent = `${time} · ${title}`;
              }
            }
          }
        }
      });
    },
    {
      root: null,
      rootMargin: '-25% 0px -50% 0px',
      threshold: 0,
    }
  );

  chapters.forEach((ch) => observer.observe(ch));
}

/**
 * 5. Accessible Lightbox Modal with Keyboard Trap & Focus Management
 */
function initLightbox() {
  const modal = document.getElementById('lightbox-modal');
  const modalImg = document.getElementById('lightbox-img');
  const modalCaption = document.getElementById('lightbox-caption');
  const modalCredit = document.getElementById('lightbox-credit');
  const modalAspect = document.getElementById('lightbox-aspect-tag');
  const closeBtn = document.getElementById('lightbox-close');
  const backdrop = document.getElementById('lightbox-backdrop');

  if (!modal || !modalImg) return;

  let lastActiveElement = null;

  function openLightbox(imgElement) {
    lastActiveElement = document.activeElement;

    const src = imgElement.getAttribute('src');
    const alt = imgElement.getAttribute('alt') || 'Wedding documentary photograph';
    const caption = imgElement.getAttribute('data-caption') || alt;
    const credit = imgElement.getAttribute('data-credit') || '';
    const aspect = imgElement.getAttribute('data-aspect') || '';

    modalImg.src = src;
    modalImg.alt = alt;
    modalCaption.textContent = caption;
    modalCredit.textContent = credit ? `Photo: ${credit}` : '';
    modalAspect.textContent = aspect ? `Aspect Ratio ${aspect}` : 'Photograph';

    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';

    // Focus close button on open
    setTimeout(() => {
      if (closeBtn) closeBtn.focus();
    }, 50);
  }

  function closeLightbox() {
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    modalImg.src = '';

    // Restore focus to triggering element
    if (lastActiveElement && typeof lastActiveElement.focus === 'function') {
      lastActiveElement.focus();
    }
  }

  // Attach click listeners to all clickable media
  const mediaContainers = document.querySelectorAll('.editorial-media:not(.editorial-placeholder-frame), .hero-media-wrapper');
  mediaContainers.forEach((container) => {
    const img = container.querySelector('img');
    if (!img) return;

    container.setAttribute('tabindex', '0');
    container.setAttribute('role', 'button');
    container.setAttribute('aria-label', `View photograph: ${img.alt || 'Wedding story image'}`);

    container.addEventListener('click', () => openLightbox(img));
    container.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        openLightbox(img);
      }
    });
  });

  if (closeBtn) closeBtn.addEventListener('click', closeLightbox);
  if (backdrop) backdrop.addEventListener('click', closeLightbox);

  // Keyboard navigation & Focus Trap
  window.addEventListener('keydown', (e) => {
    if (!modal.classList.contains('is-open')) return;

    if (e.key === 'Escape') {
      closeLightbox();
      return;
    }

    if (e.key === 'Tab') {
      const focusable = modal.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
      const focusableArr = Array.prototype.slice.call(focusable);
      if (focusableArr.length === 0) return;

      const firstElement = focusableArr[0];
      const lastElement = focusableArr[focusableArr.length - 1];

      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          lastElement.focus();
          e.preventDefault();
        }
      } else {
        if (document.activeElement === lastElement) {
          firstElement.focus();
          e.preventDefault();
        }
      }
    }
  });
}

/**
 * 6. Back-to-Top Button
 */
function initBackToTop() {
  const btn = document.getElementById('back-to-top');
  if (!btn) return;

  btn.addEventListener('click', () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
    });
  });
}

/**
 * 7. Graceful Image Error Handling & Fallbacks
 */
function initImageErrorFallbacks() {
  const images = document.querySelectorAll('img');
  images.forEach((img) => {
    img.addEventListener('error', () => {
      console.warn(`[Editorial Image] Notice: '${img.src}' not found or loading. Preserving layout geometry.`);
      const parent = img.closest('.editorial-media');
      if (parent) {
        parent.classList.add('image-fallback-active');
      }
    });
  });
}
