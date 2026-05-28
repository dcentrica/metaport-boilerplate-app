<%-- This sidebar template is used when a page is lower than top-level (> 1) in the sitetree and has
     sibling pages (same parent & level). If the current page has children, links to those pages are
     rendered as well. See layout/Page.ss for the display conditions. --%>
<aside class="page-menu">
    <nav class="page-menu__nav" aria-labelledby="page-menu-heading">
        <h2 id="page-menu-heading" class="h5 page-menu__heading">
            <a href="$Parent.Link" class="page-menu__heading-link">$Parent.Title</a>
        </h2>
        <ul class="page-menu__list">
        <% loop $Menu($PageLevel) %>
            <% if $isCurrent %>
                <li class="page-menu__list-item page-menu__list-item--current">
                    $Title
                    <% if $Children %>
                        <ul class="page-menu__child-list">
                            <% loop $Children %>
                                <li class="page-menu__list-item page-menu__list-item--child"><a href="$Link">$Title</a></li>
                            <% end_loop %>
                        </ul>
                    <% end_if %>
                </li>
            <% else %>
                <li class="page-menu__list-item"><a href="$Link">$Title</a></li>
            <% end_if %>
        <% end_loop %>
        </ul>
    </nav>
</aside>
