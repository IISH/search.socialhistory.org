{* Display Title *}
{literal}
<script language="JavaScript" type="text/javascript">
    // <!-- avoid HTML validation errors by including everything in a comment.
    function subjectHighlightOn(subjNum, partNum) {
        // Create shortcut to YUI library for readability:
        var yui = YAHOO.util.Dom;

        for (var i = 0; i < partNum; i++) {
            var targetId = "subjectLink_" + subjNum + "_" + i;
            var o = document.getElementById(targetId);
            if (o) {
                yui.addClass(o, "hoverLink");
            }
        }
    }

    function subjectHighlightOff(subjNum, partNum) {
        // Create shortcut to YUI library for readability:
        var yui = YAHOO.util.Dom;

        for (var i = 0; i < partNum; i++) {
            var targetId = "subjectLink_" + subjNum + "_" + i;
            var o = document.getElementById(targetId);
            if (o) {
                yui.removeClass(o, "hoverLink");
            }
        }
    }
    // -->
</script>
{/literal}
{* Display Cover Image *}

{if $coreThumbMedium}
<div class="alignright">
    {if $coreThumbLarge}<a href="{$coreThumbLarge|escape}">{/if}
    <img alt="{translate text='Cover Image'}" class="recordcover" src="{$coreThumbMedium|escape}">
    {if $coreThumbLarge}</a>{/if}
</div>
    {else}
{* <img src="{$path}/bookcover.php" alt="{translate text='No Cover Image'}"> *}
{/if}

{* End Cover Image *}

{* Display Title *}
<h1>{$coreShortTitle|escape}
{if $coreSubtitle}{$coreSubtitle|escape}{/if}
{if $coreTitleSection}{$coreTitleSection|escape}{/if}
{* {if $coreTitleStatement}{$coreTitleStatement|escape}{/if} *}
</h1>
{* End Title *}

{*{if $coreSummary}<p>{$coreSummary|truncate:300:"..."|escape} <a
        href='{$url}/Record/{$id|escape:"url"}/Description#tabs'>{translate text='Full description'}</a></p>{/if}*}

{* Display Main Details *}
<table cellpadding="2" cellspacing="0" border="0" class="citation" summary="{translate text='Bibliographic Details'}">
{if !empty($coreNextTitles)}
    <tr valign="top">
        <th>{translate text='New Title'}:</th>
        <td>
            {foreach from=$coreNextTitles item=field name=loop}
                <a href="{$url}/Search/Results?lookfor=%22{$field|escape:"url"}%22&amp;type=Title">{$field|escape}</a><br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($corePrevTitles)}
    <tr valign="top">
        <th>{translate text='Previous Title'}:</th>
        <td>
            {foreach from=$corePrevTitles item=field name=loop}
                <a href="{$url}/Search/Results?lookfor=%22{$field|escape:"url"}%22&amp;type=Title">{$field|escape}</a><br>
            {/foreach}
        </td>
    </tr>
{/if}

{if $corePeriod}
    <tr valign="top">
        <th>{translate text='Period'}:</th>
        <td>{translate text=$corePeriod}</td>
    </tr>
{/if}

{if $corePhysical}
    <tr valign="top">
        <th>{translate text='Physical'}:</th>
        <td>{translate text=$corePhysical}</td>
    </tr>
{/if}

    <!-- EAD extended -->
{if !empty($coreAccess)}
    <tr valign="top">
        <th>{translate text='Access'}:</th>
        <td>{translate text=$coreAccess[0]}</td>
    </tr>
    {if sizeof($coreAccess) > 1}
        <tr valign="top">
            <th/>
            <td>{$coreAccess[1]}
                {if !empty($coreAccessRestrictionsHref)}<br/>(<a target="_blank" href="{$coreAccessRestrictionsHref}">More
                    information on this website</a>)
                {/if}
            </td>
        </tr>
    {/if}
    {if sizeof($coreAccess) > 2}
        <tr valign="top">
            <th/>
        <td>
            {if $coreAccess[0]=="Closed" || $coreAccess[0] == "Gesloten"}
                <a href="{translate text='archive.closed.href'}" target="_blank">{translate text='archive.closed'}</a></td>
                {else}
                <a href="{translate text='archive.restricted.href'} target="_blank"">{translate text='archive.restricted'}
                </a></td>
            {/if}
        </tr>
    {/if}
{/if}

{if !empty($coreCollection)}
    <tr valign="top">
        <th>{translate text='Collection'}:</th>
        <td>{$coreCollection}</td>
    </tr>
{/if}

{if !empty($coreAuthor)}
    <tr valign="top">
        <th>{translate text=$coreAuthorRole}:</th>
        <td>{$coreAuthor}</td>
    </tr>
{/if}

{if $recordLanguage}
    <tr valign="top">
        <th>{translate text='Language'}:</th>
        <td>{foreach from=$recordLanguage item=lang}{$lang|escape}<br>{/foreach}</td>
    </tr>{/if}

{if !empty($coreGeography)}
    <tr valign="top">
        <th>{translate text='Geography'}:</th>
        <td>{foreach from=$coreGeography item=lang}{$lang|escape}<br>{/foreach}</td>
    </tr>
{/if}

{if $coreOpenURL}
    <tr valign="top">
        <th>{translate text='Online Access'}:</th>
        <td>
        {include file="Search/openurl.tpl" openUrl=$coreOpenURL}<br/>
        </td>
    </tr>
{/if}

{*
    <tr valign="top">
        <th>{translate text='Tags'}:</th>
        <td>
      <span style="float:right;">
        <a href="{$url}/Record/{$id|escape:"url"}/AddTag" class="tool add"
           onClick="getLightbox('Record', 'AddTag', '{$id|escape}', null, '{translate text="Add Tag"}'); return false;">{translate text="Add"}</a>
      </span>

            <div id="tagList">
            {if $tagList}
                {foreach from=$tagList item=tag name=tagLoop}
                    <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape:"html"}</a>
                    ({$tag->cnt}){if !$smarty.foreach.tagLoop.last}, {/if}
                {/foreach}
                {else}
                {translate text='No Tags'}, {translate text='Be the first to tag this record'}!
            {/if}
            </div>
        </td>
    </tr>
*}
</table>
{* End Main Details *}
