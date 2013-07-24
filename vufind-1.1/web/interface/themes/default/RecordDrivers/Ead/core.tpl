{if $tab=='ArchiveContentList' || $tab=='ArchiveAppendices'}
    <iframe id="archnav"></iframe>
{literal}
    <script type='text/javascript'>

        var archnav = $('#archnav');
        var position = $('#bd').position();
        var offsetW = position.left - 35;
        var marker = position.top;   // Do not go lower than this one.
        position = marker;

        var treeTop = $('body').height() - position - 50;
        archnav.load(function () {
            treeTop = $(this).contents().find('.tree').children().last().position().top + 30;
            s();
        });

        function s() {
            offsetW = $('#bd').position().left - 35;
            var h = $('body').height() - position - 50;
            if (h > treeTop) h = treeTop;
            if (offsetW > 50)
                archnav.css({'display': 'block', 'height': h + 'px', width: offsetW + 'px' });
            else
                archnav.css({'display': 'none'});
        }

        $(window).resize(s);
        $(window).scroll(function () {
            var scrollTop = $(window).scrollTop();
            position = marker - scrollTop;
            if (position < 0) position = 0;
            archnav.css('top', position + 'px');
            s();
        });
        //s();

        $("#archnav").attr('src', '{/literal}{$baseUrl}/{$tab}{literal}Navigation');
    </script>
{/literal}
    <link href="{$visualmets_url}/css/themes/default/style.css" rel="stylesheet" type="text/css" media="all"
          id="theme"/>
    <script type="text/javascript" src="{$visualmets_url}/js/mets2viewer.min.js"></script>
    <script type="text/javascript" src="{$visualmets_url}/js/init.js"></script>
{/if}

{$ead}

{literal}
    <script type='text/javascript'>
        $('.m').each(function () {
            var metsId = encodeURI($(this).attr('title'));
            var a = $('<a href="' + $(this).attr('title') + '">' + $(this).text() + '<\/a>');
            $(a).click(function () {
                var parent = $(this).parent();
                var div = $(parent).next();
                if ($(div).hasClass('mets-embedded'))
                    $(div).remove();
                else
                    $('<div class="mets-embedded"><div class="mets-container mets-hide"></div></div>').insertAfter(parent).find(">:first-child").mets2Viewer({
                        initialize: {
                            'metsId': metsId,
                            'defaults': true,
                            'pager': {
                                'start': 0,
                                'rows': -1
                            }
                        }
                    });

                return false;
            });

            $(a).insertAfter(this);
            $(this).remove();
        })
    </script>
{/literal}

