<div class="span-18">
  {if $user->cat_username}
    <h3>{translate text='Your Checked Out Items'}</h3>
    {if $transList}
    <ul class="recordSet">
    {foreach from=$transList item=resource name="recordLoop"}
      <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
        <div id="record{$resource.id|escape}">
          <div class="span-2">
            {if $resource.isbn}
              <img src="{$path}/bookcover.php?isn={$resource.isbn|@formatISBN}&amp;size=small" class="summcover" alt="{translate text='Cover Image'}"/>
            {else}
              <img src="{$path}/bookcover.php" class="summcover" alt="{translate text='No Cover Image'}"/>
            {/if}
          </div> 
          <div class="span-10">
            <a href="{$url}/Record/{$resource.id|escape:"url"}" class="title">{$resource.title|escape}</a><br/>
            {if $resource.author}
              {translate text='by'}: <a href="{$url}/Author/Home?author={$resource.author|escape:"url"}">{$resource.author|escape}</a><br/>
            {/if}
            {if $resource.tags}
              {translate text='Your Tags'}:
              {foreach from=$resource.tags item=tag name=tagLoop}
                <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape}</a>{if !$smarty.foreach.tagLoop.last},{/if}
              {/foreach}
              <br/>
            {/if}
            {if $resource.notes}
              {translate text='Notes'}: {$resource.notes|escape}<br/>
            {/if}
            {if is_array($resource.format)}
              {foreach from=$resource.format item=format}
                <span class="iconlabel {$format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$format}</span>
              {/foreach}
            {else}
              <span class="iconlabel {$resource.format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$resource.format}</span>
            {/if}
            <br/>
            <strong>{translate text='Due'}: {$resource.duedate|escape}</strong>
          </div>
          <div class="clear"></div>
        </div>
      </li>
    {/foreach}
    </ul>
    {else}
      {translate text='You do not have any items checked out'}.
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
</div>

<div class="span-5 last">
  {include file="MyResearch/menu.tpl"}
</div>

<div class="clear"></div>