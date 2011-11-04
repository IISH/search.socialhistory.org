<table class="citation">


{if !empty($coreURLs)}
    <tr>
        <th>{translate text='eadxml'}</th>
        <td>{foreach from=$coreURLs item=desc key=currentUrl name=loop}
            <a href="{if $proxy}{$proxy}/login?url={$currentUrl|escape:"url"}{else}{$currentUrl|escape}{/if}">{$desc|escape}</a><br/>
        {/foreach}
        </td>
    </tr>
{/if}

{* No escaping is necessary here -- $details is preformatted HTML. *}
{$details}

</table>