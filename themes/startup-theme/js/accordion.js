export default function() {
    /**
     * Accordions
     *
     * Looks for elements with the css class `accordion__toggle`
     * and toggles the display of the accordion item contents when clicked.
     *
     * Currently used on the navigation sub menus but designed for multi-use.
     */
    const accordions = document.querySelectorAll('.accordion__toggle');

    if (accordions.length) {
        accordions.forEach(function(accordion) {
            accordion.addEventListener('click', toggleAccordion);
        })
    }

    // Close opened accordion items when clicking off them if they've opted in to that behaviour
    document.body.addEventListener('click', (e) => {
        document.querySelectorAll('.accordion__item.is-active[data-close-on-defocus]').forEach((item) => {
            if (e.target.closest('.accordion__item') === item) {
                return;
            }
            item.classList.remove('is-active');
            item.querySelector('.accordion__toggle').setAttribute('aria-expanded', 'false');
        });
    });

    function toggleAccordion(el) {
        const link = el.target.closest('.accordion__toggle');
        const currentItem = link.closest('.accordion__item');
        const parent = link.closest('.accordion');
        const allItems = parent.querySelectorAll('.accordion__item');

        /**
         * Adds the class `is-active` to the `accordion__item` element
         * so that we can style the accordion states.
         */
        link.setAttribute('aria-expanded', link.getAttribute('aria-expanded') !== 'true');
        currentItem.classList.toggle('is-active');

        /**
         * Only allow for one accordion item to be open at a time
         */
        if (allItems.length) {
            allItems.forEach(function(item) {
                if (item !== currentItem) {
                    item.classList.remove('is-active');
                    item.querySelector('.accordion__toggle').setAttribute('aria-expanded', 'false');
                }
            })
        }
    }
}
