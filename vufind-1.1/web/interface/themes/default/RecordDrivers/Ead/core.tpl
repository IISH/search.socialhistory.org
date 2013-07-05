{if $tab=='ArchiveContentList' || $tab=='ArchiveAppendices'}
    <iframe id="archnav" src="{$baseUrl}/{$tab}Navigation"></iframe>
{/if}

{$ead}

{if $tab=='ArchiveContentList' || $tab=='ArchiveAppendices'}
    {literal}
        <script type='text/javascript'>

            var archnav = $('#archnav') ;
            var position = $('#tabnavarch').position();
            var w = position.left-60;
            var marker = position.top;   // Do not go lower than this one.
            position = marker;
            var offset = $('body').height() - position - 50;
            function s() {
                var h = $('body').height() - position - 50;
                archnav.css({'height': h + 'px', width: w + 'px' })
            }
            $(window).resize(s);
            $(window).scroll(function () {
                var scrollTop = $(window).scrollTop();
                position = marker - scrollTop;
                if (position < 0) position = 0;
                archnav.css('top', position + 'px');
                s();
            });
            s();
        </script>
    {/literal}
{/if}

{literal}
    <script type='text/javascript'>
        $(function () {
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
        });
    </script>
{/literal}