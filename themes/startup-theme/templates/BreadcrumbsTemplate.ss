<nav class="breadcrumbs" aria-label="Breadcrumbs">
    <ol class="breadcrumbs__list">
        <li class="breadcrumbs__list-item">
            <a href="$BaseURL"><%t StartupTheme.BREADCRUMBS_HOME 'Home' %></a>
            <span class="breadcrumbs__list-delimiter" aria-hidden="true">/</span>
        </li>
        <% loop $Pages %>
            <% if not $IsLast && not $isHomePage %>
                <li class="breadcrumbs__list-item">
                    <% if not $Up.Unlinked %><a href="$Link"><% end_if %>$MenuTitle.XML<% if not Up.Unlinked %></a><% end_if %>
                    <span class="breadcrumbs__list-delimiter" aria-hidden="true">/</span>
                </li>
            <% end_if %>
        <% end_loop %>
    </ol>
</nav>
