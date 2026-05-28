<%-- This sidebar template is used when a page is top-level (1) in the sitetree and has
     child pages. See layout/Page.ss for the display conditions. --%>
<aside class="page-menu">
    <nav class="page-menu__nav" aria-labelledby="page-menu-heading">
        <h2 id="page-menu-heading" class="h5 page-menu__heading">$Title</h2>
        <ul class="page-menu__list">
            <% loop $Children %>
                <li class="page-menu__list-item"><a href="$Link">$Title</a></li>
            <% end_loop %>
        </ul>
    </nav>
</aside>
