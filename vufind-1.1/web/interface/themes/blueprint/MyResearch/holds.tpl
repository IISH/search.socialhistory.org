<div class="span-18">
  {if $user->cat_username}
    <h3>{translate text='Your Holds and Recalls'}</h3>
    {if is_array($recordList)}
    <ul class="recordSet">
    {foreach from=$recordList item=resource name="recordLoop"}
      <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
        <div id="record{$resource.id|escape}">
          <div class="span-2">
            {if $resource.isbn.0}
              <img src="{$path}/bookcover.php?isn={$resource.isbn.0|@formatISBN}&amp;size=small" class="summcover" alt="{translate text='Cover Image'}"/>
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
              <strong>{translate text='Your Tags'}:</strong>
              {foreach from=$resource.tags item=tag name=tagLoop}
                <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape}</a>{if !$smarty.foreach.tagLoop.last},{/if}
              {/foreach}
              <br/>
            {/if}
            {if $resource.notes}
              <strong>{translate text='Notes'}:</strong> {$resource.notes|escape}<br/>
            {/if}

            {if is_array($resource.format)}
              {foreach from=$resource.format item=format}
                <span class="iconlabel {$format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$format}</span>
              {/foreach}
            {else}
              <span class="iconlabel {$resource.format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$resource.format}</span>
            {/if}
            <br/>
            <strong>{translate text='Created'}:</strong> {$resource.createdate|escape} |
            <strong>{translate text='Expires'}:</strong> {$resource.expiredate|escape}
          </div>
          <div class="clear"></div>
        </div>
      </li>
    {/foreach}
    </ul>
    {else}
      {translate text='You do not have any holds or recalls placed'}.
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
</div>

<div class="span-5 last">    
  {include file="MyResearch/menu.tpl"}
</div>

<div class="clear"></div>
