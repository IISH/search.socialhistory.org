{if $recordFormat[0] == 'Books and brochures' || $recordFormat[0] == 'Serials'}{literal}
    <script type="text/javascript">
        $(document).ready(function () {
            setButtons();
        });
        /* ready */
    </script>
{/literal}
{/if}
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
{if $coreDownloadable && $coreHasVideo}
	<div id="videoContainer">
		<video controls preload="none" style="width: 100%; height: 100%;" width="300"
		       poster="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2">
			<source src="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level1" type='video/mp4'/>

			<!-- Image as a last resort -->
			<img src="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level2" width="300"
			     title="No video playback capabilities" />
		</video>
	</div>
{elseif $coreThumbMedium}
    <div class="alignright">
        {if $coreThumbLarge}
        {if ( empty($coreIsShownBy) )}<a href="{$coreThumbLarge|escape}">{else}<a
                    href="{$imageUrl}" target="_blank">{/if}
                {/if}
                <img id="cover" title='{$coreShortTitle|escape|regex_replace:"/\s.\Z/":""}'
                     alt="{translate text='Cover Image'}" class="recordcover" src="{$coreThumbMedium|escape}">
                {if $coreThumbLarge}</a>{/if}
    </div>
{else}
{* <img src="{$path}/bookcover.php" alt="{translate text='No Cover Image'}"> *}
{/if}

{* End Cover Image *}

{* Display Title *}
<h1>{$coreShortTitle|escape|regex_replace:"/\s.\Z/":""}
    {*{if $coreSubtitle}{$coreSubtitle|escape}{/if}
    {if $coreTitleSection}{$coreTitleSection|escape}{/if}*}
    {* {if $coreTitleStatement}{$coreTitleStatement|escape}{/if} *}
</h1>
{* End Title *}

{*
{if $coreSummary}<p>{$coreSummary|truncate:300:"..."|escape} <a
        href='{$url}/Record/{$id|escape:"url"}/Description#tabs'>{translate text='Full description'}</a></p>{/if}
*}

{* Display Main Details *}
<table cellpadding="2" cellspacing="0" border="0" class="citation" summary="{translate text='Bibliographic Details'}">
{if !empty($coreNextTitles)}
    <tr valign="top">
        <th>{translate text='New Title'}:</th>
        <td>
            {foreach from=$coreNextTitles item=field name=loop}
                <a href="{$url}/Search/Results?lookfor=%22{$field|escape:"url"}%22&amp;type=Title">{$field|escape}</a>
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($corePrevTitles)}
    <tr valign="top">
        <th>{translate text='Previous Title'}:</th>
        <td>
            {foreach from=$corePrevTitles item=field name=loop}
                <a href="{$url}/Search/Results?lookfor=%22{$field|escape:"url"}%22&amp;type=Title">{$field|escape}</a>
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

<tr valign="top">
    <th>{*{translate text='CoreFormat'}*}</th>
    <td>
        {if is_array($recordFormat)}
            {foreach from=$recordFormat item=displayFormat name=loop}
                <span class="iconlabel {$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat}</span>
            {/foreach}
        {else}
            <span class="iconlabel {$recordFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$recordFormat}</span>
        {/if}
    </td>
</tr>

{if !empty($authors)}
	{foreach from=$authors key=role item=authorGroup name=loop}
		<tr valign="top">
			<th>{translate text=$role}:</th>
			<td>
				{foreach from=$authorGroup item=author name=loop}
					<a href="{$url}/Author/Home?author={$author.link|escape:"url"}">{$author.name}</a>
					{if !$smarty.foreach.loop.last}<br/>{/if}
				{/foreach}
			</td>
		</tr>
	{/foreach}
{/if}

{if !empty($coreArticle)}
    <tr valign="top">
        <th>{translate text='Published in'}:</th>
        <td>{$coreArticle}</td>
    </tr>
{/if}

{if !empty($corePeriod)}
    <tr valign="top">
        <th>{translate text='Period'}:</th>
        <td>{foreach from=$corePeriod item=period name=loop}
                <a href="{$url}/Search/Results?era_facet%3A%22{$period}%22">{$period}</a>
                {if !$smarty.foreach.loop.last}<br/>{/if}
            {/foreach}</td>
    </tr>
{/if}

{if $journal}
	<tr valign="top">
		<th>{translate text='Journal'}:</th>
		<td>
			<a href="{$url}/Search/Results?lookfor={$journal|escape:"url"}&amp;type=Title">
				{$journal|escape}
			</a>
		</td>
	</tr>
{/if}

{if $recordLanguage}
    <tr valign="top">
    <th>{translate text='Language'}:</th>
    <td>{foreach from=$recordLanguage item=lang}{$lang|escape}<br>{/foreach}</td>
    </tr>{/if}

{if !empty($extendedSummary)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Summary'}:</th>
        <td>
            {foreach from=$extendedSummary item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedDateSpan)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Published'}:</th>
        <td>
            {foreach from=$extendedDateSpan item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedPhysical)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Physical Description'}:</th>
        <td>
            {foreach from=$extendedPhysical item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedFrequency)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Publication Frequency'}:</th>
        <td>
            {foreach from=$extendedFrequency item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedPlayTime)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Playing Time'}:</th>
        <td>
            {foreach from=$extendedPlayTime item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedSystem)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Format'}:</th>
        <td>
            {foreach from=$extendedSystem item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedAudience)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Audience'}:</th>
        <td>
            {foreach from=$extendedAudience item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedAwards)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Awards'}:</th>
        <td>
            {foreach from=$extendedAwards item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedCredits)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Production Credits'}:</th>
        <td>
            {foreach from=$extendedCredits item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedBibliography)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Bibliography'}:</th>
        <td>
            {foreach from=$extendedBibliography item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedISBNs)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='ISBN'}:</th>
        <td>
            {foreach from=$extendedISBNs item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedISSNs)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='ISSN'}:</th>
        <td>
            {foreach from=$extendedISSNs item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedRelated)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Related Items'}:</th>
        <td>
            {foreach from=$extendedRelated item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedAccess)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Access'}:</th>
        <td>
            {foreach from=$extendedAccess item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedFindingAids)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Finding Aid'}:</th>
        <td>
            {foreach from=$extendedFindingAids item=field name=loop}
                {$field|escape}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{* Avoid errors if there were no rows above *}
{*{if !$extendedContentDisplayed}
<tr>
    <td>&nbsp;</td>
</tr>
{/if}*}

{if !empty($corePublications)}
    <tr valign="top">
        <th>{translate text='Published'}</th>
        <td>
            {foreach from=$corePublications item=field name=loop}
                {$field|escape}{if !empty($extendedDateSpanPublisher)}, {$extendedDateSpanPublisher}{/if}
                <br/>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($coreEdition)}
    <tr valign="top">
        <th>{translate text='Edition'}:</th>
        <td>
            {$coreEdition|escape}
        </td>
    </tr>
{/if}

{* Display series section if at least one series exists. *}
{if !empty($coreSeries)}
    <tr valign="top">
        <th>{translate text='Series'}:</th>
        <td>
            {foreach from=$coreSeries item=field name=loop}
            {* Depending on the record driver, $field may either be an array with
               "name" and "number" keys or a flat string containing only the series
               name.  We should account for both cases to maximize compatibility. *}
                {if is_array($field)}
                    {if !empty($field.name)}
                        <a href="{$url}/Search/Results?lookfor=%22{$field.name|escape:"url"}%22&amp;type=Series">{$field.name|escape}</a>
                        {if !empty($field.number)}
                            {$field.number|escape}
                        {/if}
                        <br>
                    {/if}
                {else}
                    <a href="{$url}/Search/Results?lookfor=%22{$field|escape:"url"}%22&amp;type=Series">{$field|escape}</a>
                    <br>
                {/if}
            {/foreach}
        </td>
    </tr>
{/if}

{*{if !empty($coreSubjects)}
<tr valign="top">
    <th>{translate text='Subjects'}:</th>
    <td>
        {foreach from=$coreSubjects item=field name=loop}
            {assign var=subject value=""}
            {foreach from=$field item=subfield name=subloop}
                {if !$smarty.foreach.subloop.first} &gt; {/if}
                {assign var=subject value="$subject $subfield"}
                <a id="subjectLink_{$smarty.foreach.loop.index}_{$smarty.foreach.subloop.index}"
                   href="{$url}/Search/Results?lookfor=%22{$subject|escape:"url"}%22&amp;type=Subject"
                   onmouseover="subjectHighlightOn({$smarty.foreach.loop.index}, {$smarty.foreach.subloop.index});"
                   onmouseout="subjectHighlightOff({$smarty.foreach.loop.index}, {$smarty.foreach.subloop.index});">{$subfield|escape}</a>
            {/foreach}
            <br>
        {/foreach}
    </td>
</tr>
{/if}*}

{if !empty($coreGenres)}
    <tr valign="top">
        <th>{translate text='Genres'}:</th>
        <td>
            {foreach from=$coreGenres item=field name=loop}
                {assign var=subject value=""}
                {foreach from=$field item=subfield name=subloop}
                    {if !$smarty.foreach.subloop.first} &gt; {/if}
                    {assign var=subject value="$subject $subfield"}
                    <a id="subjectLink_{$smarty.foreach.loop.index}_{$smarty.foreach.subloop.index}"
                       href="{$url}/Search/Results?lookfor=%22{$subject|escape:"url"}%22&amp;type=Genre"
                       onmouseover="subjectHighlightOn({$smarty.foreach.loop.index}, {$smarty.foreach.subloop.index});"
                       onmouseout="subjectHighlightOff({$smarty.foreach.loop.index}, {$smarty.foreach.subloop.index});">{$subfield|escape}</a>
                {/foreach}
                <br>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($extendedNotes)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top">
        <th>{translate text='Notes'}: </th>
        <td>
            {foreach from=$extendedNotes item=field name=loop}
                {$field|escape}<br/>
            {/foreach}
        </td>
    </tr>
{/if}

{if !empty($coreCopyrightB)}
    <tr valign="top">
        <th>{translate text='Copyright'}:</th>
        <td>{translate text=$coreCopyrightB}</td>
    </tr>
{/if}

{if !empty($coreURLs) || $coreOpenURL}
    <tr valign="top">
        <th>{translate text='Online Access'}:</th>
        <td>
            {foreach from=$coreURLs item=desc key=currentUrl name=loop}
                <a href="{if $proxy}{$proxy}/login?url={$currentUrl|escape:"url"}{else}{$currentUrl|escape}{/if}">{$desc|escape}</a>
                <br/>
            {/foreach}
            {if $coreOpenURL}
                {include file="Search/openurl.tpl" openUrl=$coreOpenURL}
                <br/>
            {/if}
        </td>
    </tr>
{/if}

{if !empty($coreClassification)}
    <tr valign="top">
        <th>{translate text='Classification'}:</th>
        <td><a href="{$url}/Search/Results?lookfor={$coreClassification[1]|escape:"url"}">{$coreClassification[1]}</a>
        </td>
    </tr>
{/if}

{if !empty($coreCollector)}
    <tr valign="top">
        <th>{translate text='Collector'}:</th>
        <td>
            {if is_array($coreCollector)}
                {foreach from=$coreCollector item=collector name=loop}
                    <a href="{$url}/Search/Results?lookfor={$collector|regex_replace:"/[,\.].\Z/":""|escape:"url"}&type=Collector">{translate text=$collector}</a>
                {/foreach}
            {else}
                <a href="{$url}/Search/Results?lookfor={$coreCollector|regex_replace:"/[,\.].\Z/":""|escape:"url"}&type=Collector">{translate text=$coreCollector}</a>
            {/if}
        </td>
    </tr>
{/if}

{if !empty($coreMarc600)}
    <tr valign="top">
        <th>{translate text=coreMarc600Label}:</th>
        <td>
            {foreach from=$coreMarc600 item=field name=loop}
	            {if isset($field.authority)}
		            <a href="{$url}/Search/Results?filter[]=authority_facet:{$field.authority|escape:"url"}">{$field.value|escape}</a>
	            {else}
		            <a href="{$url}/Search/Results?lookfor={$field.value|escape:"url"}">{$field.value|escape}</a>
	            {/if}

	            {if !$smarty.foreach.loop.last}
	                <br/>
	            {/if}
            {/foreach}
        </td>
    </tr>
{/if}
{if !empty($coreMarc610)}
    <tr valign="top">
        <th>{translate text=coreMarc610Label}:</th>
        <td>
            {foreach from=$coreMarc610 item=field name=loop}
	            {if isset($field.authority)}
		            <a href="{$url}/Search/Results?filter[]=authority_facet:{$field.authority|escape:"url"}">{$field.value|escape}</a>
	            {else}
		            <a href="{$url}/Search/Results?lookfor={$field.value|escape:"url"}">{$field.value|escape}</a>
	            {/if}

	            {if !$smarty.foreach.loop.last}
		            <br/>
	            {/if}
            {/foreach}
        </td>
    </tr>
{/if}
{if !empty($coreMarc611)}
    <tr valign="top">
        <th>{translate text=coreMarc611Label}:</th>
        <td>
            {foreach from=$coreMarc611 item=field name=loop}
                <a
                href="{$url}/Search/Results?lookfor={$field|escape:"url"}">{$field|escape}</a>{if !$smarty.foreach.loop.last}
                <br/>
            {/if}
            {/foreach}
        </td>
    </tr>
{/if}
{if !empty($coreMarc650)}
    <tr valign="top">
        <th>{translate text=coreMarc650Label}:</th>
        <td>
            {foreach from=$coreMarc650 item=field name=loop}
	            {if isset($field.authority)}
		            <a href="{$url}/Search/Results?filter[]=authority_facet:{$field.authority|escape:"url"}">{$field.value|escape}</a>
	            {else}
		            <a href="{$url}/Search/Results?lookfor={$field.value|escape:"url"}">{$field.value|escape}</a>
	            {/if}

	            {if !$smarty.foreach.loop.last}
		            <br/>
	            {/if}
            {/foreach}
        </td>
    </tr>
{/if}
{if !empty($coreMarc651)}
    <tr valign="top">
        <th>{translate text=coreMarc651Label}:</th>
        <td>
            {foreach from=$coreMarc651 item=field name=loop}
	            {if isset($field.authority)}
		            <a href="{$url}/Search/Results?filter[]=authority_facet:{$field.authority|escape:"url"}">{$field.value|escape}</a>
	            {else}
		            <a href="{$url}/Search/Results?lookfor={$field.value|escape:"url"}">{$field.value|escape}</a>
	            {/if}

	            {if !$smarty.foreach.loop.last}
		            <br/>
	            {/if}
            {/foreach}
        </td>
    </tr>
{/if}

{if $coreDownloadable && $coreHasAudio}
	<tr valign="top">
		<td colspan="2" id="audioContainer">
			<audio controls preload="none" style="width: 100%;">
				<source src="http://hdl.handle.net/10622/{$coreIsShownBy}?locatt=view:level1" type='audio/mp3'/>
			</audio>
		</td>
	</tr>
{/if}

{*{if !empty($coreHolding)}
<tr valign="top">
    <th>{translate text='Holding'}:</th>
<td>{foreach from=$coreHolding key=key item=value name=loop}
        <p>{$key}{if $value}<br/>{$value}{/if}</p>
    {/foreach}</td>
</tr>{/if}*}

{*
  <tr valign="top">
    <th>{translate text='Tags'}: </th>
    <td>
      <span style="float:right;">
        <a href="{$url}/Record/{$id|escape:"url"}/AddTag" class="tool add"
           onClick="getLightbox('Record', 'AddTag', '{$id|escape}', null, '{translate text="Add Tag"}'); return false;">{translate text="Add"}</a>
      </span>
      <div id="tagList">
        {if $tagList}
          {foreach from=$tagList item=tag name=tagLoop}
        <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape:"html"}</a> ({$tag->cnt}){if !$smarty.foreach.tagLoop.last}, {/if}
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
