<div class="span-18">
  {if $user->cat_username}
    <h3>{translate text='Your Profile'}</h3>
    <span class="span-3"><strong>{translate text='First Name'}:</strong></span> {$profile.firstname|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Last Name'}:</strong></span> {$profile.lastname|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Address'} 1:</strong></span> {$profile.address1|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Address'} 2:</strong></span> {$profile.address2|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Zip'}:</strong></span> {$profile.zip|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Phone Number'}:</strong></span> {$profile.phone|escape}<br class="clear"/>
    <span class="span-3"><strong>{translate text='Group'}:</strong></span> {$profile.group|escape}<br class="clear"/>
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
</div>

<div class="span-5 last">
  {include file="MyResearch/menu.tpl"}
</div>

<div class="clear"></div>