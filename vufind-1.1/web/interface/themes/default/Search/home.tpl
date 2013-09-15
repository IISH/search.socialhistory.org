<div class="searchHome">
  <b class="btop"><b></b></b>
  <div class="searchHomeContent">
    <div class="searchHomeForm">
      {include file="Search/searchbox.tpl"}
    </div>
  </div>
</div>

{if !empty($messageOfTheDay)}
    <div class="searchHomeBrowseHeader" id="messageOfTheDay"><h2>{$messageOfTheDay.title}</h2><p>{$messageOfTheDay.content}</p></div>
{/if}

{if $facetList}
  <div class="searchHomeBrowseHeader">
    {foreach from=$facetList item=details key=field}
      {* Special case: extra-wide header for call number facets: *}
      <div{if $field == "callnumber-first" || $field == "dewey-hundreds"} class="searchHomeBrowseExtraWide"{/if}>
        <h2>{translate text="home_browse"}{* {translate text=$details.label}*}</h2>
      </div>
    {/foreach}
    <br clear="all">
  </div>
  
  <div class="searchHomeBrowse">
    <div class="searchHomeBrowseInner">
      {foreach from=$facetList item=details key=field}
        {assign var=list value=$details.sortedList}
        <div{if $field == "callnumber-first" || $field == "dewey-hundreds"} class="searchHomeBrowseExtraWide"{/if}>
          <ul>
              {assign var=break value=false}
              {foreach from=$list item=currentUrl key=value name="listLoop"}
                {if $smarty.foreach.listLoop.iteration > 12}
                  {if !$break}
                    <li><a href="{$path}/Search/Advanced"><strong>{translate text="More options"}...</strong></a></li>
                    {assign var=break value=true}
                  {/if}
                {else}
                  <li><a href="{$currentUrl|escape}">{translate text=$value}</a></li>
                {/if}
              {/foreach}
          </ul>
        </div>
      {/foreach}
      <br clear="all">
    </div>
    <b class="gtop"><b></b></b>
  </div>
{/if}