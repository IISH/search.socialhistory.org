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

           {*ToDo: misschien beter geen mets viewer meteen voor preview te tonen, maar via de mets een lijstje van plaatjes.*}
{literal}
<script type='text/javascript'>
    $('.m').click(function(){
        var div = '<iframe width="400px" src="http://visualmets.socialhistoryservices.org/mets2/rest/popup.html?metsId='+$(this).attr('href')+'"><\/iframe>';
        $(div).insertAfter($(this).parent());
        return false;
    })
</script>{/literal}