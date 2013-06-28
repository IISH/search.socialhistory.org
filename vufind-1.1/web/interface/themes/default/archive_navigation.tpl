{*
<div id="tree"></div>

{literal}
    <script type="text/javascript">
        $('#tree').aciTree({
            jsonUrl: 'http://localhost/tree.js',
            itemHook: function (parent, item, itemData, level) {
                // a custom item implementation to show a link
                this.setLabel(item, {
                    label: '<a href="#' + itemData['my-hash'] + '" title="Click to jump to ' + itemData['my-hash'] + '">' + itemData.label + '<\/a>'
                });
            }})
    </script>

{/literal}

*}


