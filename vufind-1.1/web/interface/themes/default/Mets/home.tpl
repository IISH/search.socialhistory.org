<!DOCTYPE HTML>
<html lang="{$lang}">
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <link href="{$visualmets_url}/css/bootstrap.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="{$visualmets_url}/css/themes/default/style.css" rel="stylesheet" type="text/css" media="all"
          id="theme"/>
    <script type="text/javascript" src="{$visualmets_url}/js/mets2viewer.min.js"></script>
    <script type="text/javascript" src="{$visualmets_url}/js/init.js"></script>

    {literal}
        <style type="text/css">
            .ccc {
                /*width: 710px;*/
                height: 550px;
                width: 100%;
            }
        </style>
    {/literal}
</head>

<body>

<div class="ccc"><div class="mets-container mets-hide" id="metsViewSample"></div><form><input type="hidden" class="btn btn-primary pull-right btn-large save" name="metsId" value="{$metsId}"/></form></div>

</body>

</html>