import setupAccordion from './accordion.js'
import setupMobileMenu from './mobile-menu.js'
import setupDesktopMenu from './desktop-menu.js'

/**
 * Scripts are deferred until the document is loaded, so there is no need to listen to the `DOMContentLoaded` event.
 * Ensure you split functionality up into their own modules.
 */
setupAccordion()
setupMobileMenu()
setupDesktopMenu()

