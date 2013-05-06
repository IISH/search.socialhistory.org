{* Your footer *}
<div><p><strong>{translate text='Search Options'}</strong></p>
    <ul>
        <li><a href="{$path}/Search/History">{translate text='Search History'}</a></li>
        <li><a href="{$path}/Search/Advanced">{translate text='Advanced Search'}</a></li>
    </ul>
</div>
<div><p><strong>{translate text='Find More'}</strong></p>
    <ul>
        <li><a href="{$path}/Browse/Home">{translate text='Browse the Catalog'}</a></li>
        <li><a href="{$path}/AlphaBrowse/Home">{translate text='Browse Alphabetically'}</a></li>
    {*<li><a href="{$path}/Search/NewItem">{translate text='New Items'}</a></li>*}
    </ul>
</div>
<div><p><strong>{translate text='Need Help?'}</strong></p>
    <ul>
        <li><a href="{$url}/Help/Home?topic=search"
               onClick="window.open('{$url}/Help/Home?topic=search', 'Help', 'width=625, height=510'); return false;">{translate text='Search Tips'}</a>
        </li>
        <li><a href="{$url}/Iish/About" onClick="window.open('{$url}/Iish/About', '{translate text='About'}', 'width=625, height=510'); return false;">{translate text='About'}</a></li>
        <li><a href="{$url}/Iish/Databases" onClick="window.open('{$url}/Iish/Databases', '{translate text='Databases'}', 'width=625, height=510'); return false;">{translate text='Databases'}</a></li>
        <li><a target="_blank" href="{translate text='footer.href.ask'}">{translate text='Ask a Librarian'}</a></li>
        <li><a target="_blank" href="{translate text='footer.href.faq'}">{translate text='FAQs'}</a></li>
    </ul>
</div>
<div><p><strong>{translate text='more.information'}</strong></p>
    <ul>
        <li><a href="{translate text='more.information.iish'}">IISG</a></li>
        <li><a href="{translate text='more.information.neha'}">NEHA</a></li>
        <li><a href="{translate text='more.information.persmuseum'}">Persmuseum</a></li>
    </ul>
</div>

<br clear="all" />
