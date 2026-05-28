export default function() {
    /**
     * Toggle display of the mobile menu
     *
     * Looks for elements with the data attribute `data-toggle-mobile-menu`
     * and toggles the display of the mobile menu when clicked.
     */
    const toggles = document.querySelectorAll('[data-toggle-mobile-menu]');

    if (toggles.length) {
        toggles.forEach(function(toggle) {
            toggle.addEventListener('click', toggleMobileMenu);
        })
    }

    function toggleMobileMenu() {
        /**
         * Adds the class `mobile-menu-active` to the `body` element
         * so that we can style the mobile menu states.
         */
        const toggleEl = document.querySelector('body');
        toggleEl.classList.toggle('mobile-menu-is-active');
    }
}
