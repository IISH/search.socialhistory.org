<!DOCTYPE html>
<html lang="{$userLang}">

<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    {css media="screen" filename="styles.css"}
    {css media="screen" filename="iish.css"}
    {js filename="delivery_shop/example/resources/js/jquery-1.9.1.min.js"}
    {literal}
        <style type="text/css">

            ul.tree, ul.tree ul {
                list-style-type: none;
                background: url('/images/vline.png') repeat-y;
                margin: 0;
                padding: 0;
            }

            ul.tree ul {
                margin-left: 10px;
            }

            ul.tree li {
                text-align: left;
                margin: 0;
                padding: 0 12px;
                line-height: 20px;
                background: url('/images/node.png') no-repeat;
                color: #369;
                font-weight: bold;
            }

            ul.tree li.last {
                background: #fff url('/images/lastnode.png') no-repeat;
            }
        </style>
        <script type="text/javascript">
            $(function() {
                $('ul.tree li:last-child').addClass('last');
                $('a').click(function () {
                            parent.document.location.href='{/literal}{$baseUrl}{literal}/ArchiveContentList' +  $(this).attr('href');
                            return false;
                        }
                )
            });
        </script>
    {/literal}
</head>

<body>{$ead}</body>

</html>