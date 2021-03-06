<div id="bd">
  <div id="yui-main" class="content">
    <div class="yui-b first contentbox">
      <b class="btop"><b></b></b>
      <div class="yui-gf resulthead">
        {include file="Admin/menu.tpl"}
        <div class="yui-u">
          <h1>Record Management</h1>

          <h2>Single Record Operations</h2>
          {if $status}<div class="warning">{$status}</div>{/if}
          <form method="get" name="recordEdit">
           <input type="hidden" name="util" value="">
           Record Id<br>
           <input type="text" name="id" size="50"><br>
           <input type="submit" name="submit" value="View" onClick="document.forms['recordEdit'].elements['util'].value='viewRecord';">
           <input type="submit" name="submit" value="Delete" onClick="if (!confirm('Are you sure?')) return false; else document.forms['recordEdit'].elements['util'].value='deleteRecord';">
          </form>
          
          <h2>Utilities</h2>
          <dl>
            <dt><a href="{$url}/Admin/Records?util=deleteSuppressed">Delete Suppressed Records</a></dt>
            <dd>This process will delete any suppressed records from the VuFind Index.</dd>

            {* not implemented yet:
            <dt>Process Authority Records</dt>
            <dd>This process will update all records with the authority records to ensure that the authority data is included in the search index</dd>
             *}
          </dl>
        </div>
      </div>
      <b class="bbot"><b></b></b>
    </div>
  </div>
</div>