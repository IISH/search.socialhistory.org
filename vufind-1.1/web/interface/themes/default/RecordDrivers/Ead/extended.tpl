{if ( !empty($coreIsShownAt) )}
    <p>{translate text='isShownAt'}<br/><a href="http://hdl.handle.net/{$coreIsShownAt}" target="_blank">http://hdl.handle.net/{$coreIsShownAt}</a></p>{/if}
{if ( !empty($coreIsShownBy) )}
    <p>{translate text='isShownBy'}<br/><a href="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2" target="_blank">http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2</a></p>{/if}

<table border="0" class="citation"><tbody>{$details}</tbody></table>