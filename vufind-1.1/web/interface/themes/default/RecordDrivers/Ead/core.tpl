{if $tab=='ArchiveContentList'}
    {include file="archive_navigation.tpl"}
{/if}

{$ead}

{literal}
    <script type='text/javascript'>
        $('.m').each(function () {
            var url = '/Mets/Home?metsId=' + encodeURI($(this).attr('title'));
            var a = $('<a href="' + $(this).attr('title') + '">' + $(this).text() + '<\/a>');
            $(a).click(function () {
                var parent = $(this).parent();
                var iframe = $(parent).next().prop('tagName');
                if (iframe == 'DIV') {
                    $('<iframe class="metsiframe" scrolling="no"  width="730px" height="200px" src="'
                            + url + '"><\/iframe>').insertAfter(parent);
                } else {
                    $(iframe).remove();
                }
                return false;
            });
            $(a).insertAfter(this);
            $(this).remove();
        })
    </script>

{/literal}