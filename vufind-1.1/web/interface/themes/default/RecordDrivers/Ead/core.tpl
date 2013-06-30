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
{$ead}
{include file="archive_navigation.tpl"}

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