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
        $('.m').click(function () {
            var url = '/Mets/Home?metsId=' + encodeURI($(this).attr('href'));
            var iframe = '<iframe class="metsiframe" src="' + url + '"><\/iframe>';
            $(iframe).insertAfter($(this).parent());
            return false;
        })
    </script>
{/literal}