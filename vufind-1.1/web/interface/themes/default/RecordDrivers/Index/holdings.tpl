{if !empty($coreHolding)}
<h3 xmlns="http://www.w3.org/1999/html">{translate text="Holding"}</h3>
    {foreach from=$coreHolding key=key item=value name=loop}
    <p>{$key}{if $value}<br/>{$value}{/if}</p>
    {/foreach}
{/if}

<h3>{translate text="Internet"}</h3>

{if ( !empty($coreIsShownAt) )}
    <p>{translate text='isShownAt'}<br/><a href="http://hdl.handle.net/{$coreIsShownAt}" target="_blank">http://hdl.handle.net/{$coreIsShownAt}</a></p>{/if}
{if ( !empty($coreIsShownBy) )}
    <p>{translate text='isShownBy'}<br/><a href="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2" target="_blank">http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2</a></p>{/if}

{if ( !empty($coreIsShownBy) )}
    {if $language="en"}
    <h3>Use restrictions for the image</h3>
    <p>Please consult the <a href="http://socialhistory.org/en/services/copyrights" target="_blank">IISH copyright statement</a> before using this image.<br>
    The IISH does not know the copyright owner of this document, if any.
    In many cases, however, most notably for commercial purposes, permission to reproduce material in copyright is required from the copyright owner.
    The onus of establishing the copyright owner and obtaining permission rests with the user. If you are the copyright owner, please get in touch with the IISH.</p>
    {else}
    <h3>Beperkingen aan het gebruik van deze afbeelding</h3>
    Raadpleeg de <a href="http://socialhistory.org/nl/dienstverlening/auteursrechten" target="_blank">IISG Auteursrechten verklaring</a> vóór gebruik van deze afbeelding.<br/>
    Het IISG weet niet bij wie de eventuele rechten op dit document berusten. In vele gevallen dient de eigenaar van zulke rechten echter toestemming te geven voor de vermenigvuldiging van het materiaal, in het bijzonder voor commerciele doeleinden. Het vaststellen wie de eigenaar is en het verkrijgen van toestemming is de taak van de gebruiker.
    Bent u de eigenaar van de rechten, neem dan alstublieft contact op met het IISG.</p>
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

{include file="../deliverance.tpl"}
