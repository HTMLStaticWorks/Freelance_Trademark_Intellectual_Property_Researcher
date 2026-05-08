document.addEventListener('DOMContentLoaded', () => {
    // Initialize Lucide Icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    // Theme Toggling
    const themeToggleBtns = document.querySelectorAll('#theme-toggle, #theme-toggle-mobile');
    const htmlElement = document.documentElement;
    const isDark = localStorage.getItem('theme') === 'dark' || 
                   (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches);
    
    if (isDark) {
        htmlElement.classList.add('dark');
    }

    themeToggleBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            htmlElement.classList.toggle('dark');
            if (htmlElement.classList.contains('dark')) {
                localStorage.setItem('theme', 'dark');
            } else {
                localStorage.setItem('theme', 'light');
            }
        });
    });

    // RTL Toggling
    const rtlToggleBtns = document.querySelectorAll('#rtl-toggle, #rtl-toggle-mobile, #rtl-toggle-menu, #rtl-toggle-sidebar');
    rtlToggleBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const currentDir = htmlElement.getAttribute('dir');
            if (currentDir === 'rtl') {
                htmlElement.setAttribute('dir', 'ltr');
                localStorage.setItem('dir', 'ltr');
            } else {
                htmlElement.setAttribute('dir', 'rtl');
                localStorage.setItem('dir', 'rtl');
            }
        });
    });

    // Apply saved dir
    const savedDir = localStorage.getItem('dir');
    if (savedDir) {
        htmlElement.setAttribute('dir', savedDir);
    }

    // Mobile Menu Toggle
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');
    const mobileMenu = document.getElementById('mobile-menu');
    
    if (mobileMenuBtn && mobileMenu) {
        mobileMenuBtn.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });
    }

    // Scroll Animations
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.animate-on-scroll').forEach(el => {
        observer.observe(el);
    });

    // Counter Animation
    const counters = document.querySelectorAll('.counter-value');
    const counterObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target;
                const finalValue = parseInt(target.getAttribute('data-target'));
                const duration = 2000;
                const step = finalValue / (duration / 16);
                let current = 0;

                const updateCounter = () => {
                    current += step;
                    if (current < finalValue) {
                        target.innerText = Math.ceil(current);
                        requestAnimationFrame(updateCounter);
                    } else {
                        target.innerText = finalValue;
                    }
                };
                updateCounter();
                observer.unobserve(target);
            }
        });
    });

    counters.forEach(counter => {
        counterObserver.observe(counter);
    });

    // Accordion FAQ
    const accordionItems = document.querySelectorAll('.accordion-item');
    accordionItems.forEach(item => {
        const header = item.querySelector('.accordion-header');
        if (header) {
            header.addEventListener('click', () => {
                const content = item.querySelector('.accordion-content');
                const icon = item.querySelector('.accordion-icon');
                
                // Close all others
                accordionItems.forEach(otherItem => {
                    if (otherItem !== item) {
                        const otherContent = otherItem.querySelector('.accordion-content');
                        const otherIcon = otherItem.querySelector('.accordion-icon');
                        if(otherContent) otherContent.style.maxHeight = null;
                        if(otherIcon) otherIcon.style.transform = 'rotate(0deg)';
                    }
                });

                if (content.style.maxHeight) {
                    content.style.maxHeight = null;
                    if(icon) icon.style.transform = 'rotate(0deg)';
                } else {
                    content.style.maxHeight = content.scrollHeight + "px";
                    if(icon) icon.style.transform = 'rotate(180deg)';
                }
            });
        }
    });
    // Dashboard Sidebar Toggle
    const dashboardMenuBtn = document.getElementById('dashboard-menu-btn');
    const dashboardSidebar = document.getElementById('dashboard-sidebar');
    
    if (dashboardMenuBtn && dashboardSidebar) {
        dashboardMenuBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            dashboardSidebar.classList.toggle('hidden');
            dashboardSidebar.classList.toggle('fixed');
            dashboardSidebar.classList.toggle('inset-y-0');
            dashboardSidebar.classList.toggle('left-0');
            dashboardSidebar.classList.toggle('shadow-2xl');
        });

        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', (e) => {
            if (window.innerWidth < 768 && !dashboardSidebar.classList.contains('hidden') && 
                !dashboardSidebar.contains(e.target) && 
                !dashboardMenuBtn.contains(e.target)) {
                dashboardSidebar.classList.add('hidden');
                dashboardSidebar.classList.remove('fixed', 'inset-y-0', 'left-0', 'shadow-2xl');
            }
        });
    }
});

    // Accordion Logic
    const accordionButtons = document.querySelectorAll('.accordion-item button');
    accordionButtons.forEach(button => {
        button.addEventListener('click', () => {
            const item = button.closest('.accordion-item');
            
            // Close others
            const allItems = document.querySelectorAll('.accordion-item');
            allItems.forEach(i => {
                if (i !== item) i.classList.remove('active');
            });
            
            // Toggle current
            item.classList.toggle('active');
        });
    });
