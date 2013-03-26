{if !empty($coreHolding)}
    <h3>{translate text="Holding"}</h3>
    <table style="margin-bottom: 25px;">
        {foreach from=$coreHolding key=key item=value name=loop}
            <tr>
                <td><div id='item{$smarty.foreach.loop.index}'></div></td>
                <td>{$key}</td>
                <td><!-- empty --></td>
            </tr>
            {if $value.note}
            <tr>
                <td><!-- empty --></td>
                <td colspan="2">{$value.note}</td>
            </tr>
            {/if}
        {/foreach}
    </table>


    {literal}<script type="text/javascript">function setButtons(){{/literal}
    {foreach from=$coreHolding key=key item=value name=loop}
        {if $value.j}
            {literal}$("#item{/literal}{$smarty.foreach.loop.index}{literal}").determineReservationButton('{/literal}{$coreShortTitle|escape|truncate:25:"..."|regex_replace:"/\s.\Z/":""}{literal}','{/literal}{$coreIsShownAt}{literal}','{/literal}{$value.j}{literal}', false);{/literal}
        {/if}
    {/foreach}
    {literal}}/* setButtons */</script>{/literal}

{/if}   


{if ( !empty($coreIsShownAt) )}
<p>{translate text='isShownAt'}<br/><a href="http://hdl.handle.net/{$coreIsShownAt}" target="_blank">http://hdl.handle.net/{$coreIsShownAt}</a>
</p>{/if}
{if ( !empty($coreIsShownBy) )}
<p>{translate text='isShownBy'}<br/><a href="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2"
                                       target="_blank">http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2</a></p>{/if}


{if (empty($coreCopyrightA) || $coreCopyrightA != "Public Domain.") && !empty($coreIsShownBy) }
<h3>{translate text='copyright.use'}</h3>
<p><a href="{translate text='copyright.consult.href'}" target="_blank">{translate text='copyright.consult'}</a></p>
    {if empty($coreCopyrightB)}
         <p>{translate text='copyright.unknown'}</p>
            {else}
         <p>{translate text='copyright.known'}</p>
    {/if}
{/if}

{if (!empty($holdingLCCN)||!empty($isbn)||!empty($holdingArrOCLC))}
<span style="">
    <a class="{if $isbn}gbsISBN{$isbn}{/if}{if $holdingLCCN}{if $isbn} {/if}gbsLCCN{$holdingLCCN}{/if}{if $holdingArrOCLC}{if $isbn|$holdingLCCN} {/if}{foreach from=$holdingArrOCLC item=holdingOCLC name=oclcLoop}gbsOCLC{$holdingOCLC}{if !$smarty.foreach.oclcLoop.last} {/if}{/foreach}{/if}"
       style="display:none" target="_blank"><img
            src="https://www.google.com/intl/en/googlebooks/images/gbs_preview_button1.png" border="0"
            style="width: 70px; margin: 0;"/></a>
    <a class="{if $isbn}olISBN{$isbn}{/if}{if $holdingLCCN}{if $isbn} {/if}olLCCN{$holdingLCCN}{/if}{if $holdingArrOCLC}{if $isbn|$holdingLCCN} {/if}{foreach from=$holdingArrOCLC item=holdingOCLC name=oclcLoop}olOCLC{$holdingOCLC}{if !$smarty.foreach.oclcLoop.last} {/if}{/foreach}{/if}"
       style="display:none" target="_blank"><img src="{$path}/images/preview_ol.gif" border="0"
                                                 style="width: 70px; margin: 0"/></a>
    <a id="HT{$id|escape}" style="display:none" target="_blank"><img src="{$path}/images/preview_ht.gif" border="0"
                                                                     style="width: 70px; margin: 0"
                                                                     title="{translate text='View online: Full view Book Preview from the Hathi Trust'}"/></a>
  </span>
{/if}
{foreach from=$holdings item=holding key=location}
<h3>{translate text=$location}</h3>
<table cellpadding="2" cellspacing="0" border="0" class="citation"
       summary="{translate text='Holdings details from'} {translate text=$location}">
    {if $holding.0.callnumber}
        <tr>
            <th>{translate text="Call Number"}:</th>
            <td>{$holding.0.callnumber|escape}</td>
        </tr>
    {/if}
    {if $holding.0.summary}
        <tr>
            <th>{translate text="Volume Holdings"}:</th>
            <td>
                {foreach from=$holding.0.summary item=summary}
                    {$summary|escape}<br>
                {/foreach}
            </td>
        </tr>
    {/if}
    {if $holding.0.notes}
        <tr>
            <th>{translate text="Notes"}:</th>
            <td>
                {foreach from=$holding.0.notes item=data}
                    {$data|escape}<br>
                {/foreach}
            </td>
        </tr>
    {/if}
    {foreach from=$holding item=row}
        {if $row.barcode != ""}
            <tr>
                <th>{translate text="Copy"} {$row.number}</th>
                <td>
                    {if $row.reserve == "Y"}
                        {translate text="On Reserve - Ask at Circulation Desk"}
                        {else}
                        {if $row.availability}
                            <span class="available">{translate text="Available"}</span> |
                            <a href="{$url}/Record/{$id|escape:"url"}/Hold">{translate text="Place a Hold"}</a>
                            {else}
                            <span class="checkedout">{$row.status|escape}</span>
                            {if $row.duedate}
                                {translate text="Due"}: {$row.duedate|escape} |
                                <a href="{$url}/Record/{$id|escape:"url"}/Hold">{translate text="Recall This"}</a>
                            {/if}
                        {/if}
                    {/if}
                </td>
            </tr>
        {/if}
    {/foreach}
</table>
{/foreach}

{if $history}
<h3>{translate text="Most Recent Received Issues"}</h3>
<ul>
    {foreach from=$history item=row}
        <li>{$row.issue|escape}</li>
    {/foreach}
</ul>
{/if}
