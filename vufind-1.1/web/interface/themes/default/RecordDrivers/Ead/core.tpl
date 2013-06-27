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
{* Display Cover Image *}

{include file="archive_navigation.tpl"}

<div id="tabnavarch">
    <ul>
        <li{if ($tab=='ArchiveCollectionSummary' || $tab=='Description')} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveCollectionSummary">{translate text='ArchiveCollectionSummary'}</a>
        </li>
        <li{if ($tab=='ArchiveContentList')} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveContentList">{translate text='ArchiveContentList'}</a>
        </li>
        <li{if $tab=='ArchiveContentAndStructure'} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveContentAndStructure">{translate text='ArchiveContentAndStructure'}</a>
        </li>
        <li{if $tab=='ArchiveSubjects'} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveSubjects">{translate text='ArchiveSubjects'}</a>
        </li>
        <li{if $tab=='ArchiveAccessAndUse'} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveAccessAndUse">{translate text='ArchiveAccessAndUse'}</a>
        </li>
        <li{if $tab=='ArchiveAppendices'} class="active"{/if}>
            <a href="{$url}/Record/{$id|escape:"url"}/ArchiveAppendices">{translate text='ArchiveAppendices'}</a>
        </li>
    </ul>
    <div style="clear:both;"></div>
</div>

<div id="arch">{$ead}</div>