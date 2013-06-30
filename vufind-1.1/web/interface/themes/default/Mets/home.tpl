<!DOCTYPE html>
<html lang="{$lang}">

<head>
    <title></title>
    {css media="screen" filename="styles.css"}
    {css media="screen" filename="iish.css"}
    <style type="text/css">
        {literal}
        body {
            background-color: white;
        }

        .black_overlay{
            display: none;
            position: absolute;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            background-color: black;
            z-index:1001;
            -moz-opacity: 0.8;
            opacity:.80;
            filter: alpha(opacity=80);
        }
        .white_content {
            display: none;
            position: absolute;
            top: 25%;
            left: 25%;
            width: 50%;
            height: 50%;
            padding: 16px;
            border: 16px solid orange;
            background-color: white;
            z-index:1002;
            overflow: auto;
        }

        {/literal}
    </style>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
</head>

<body>{$body}</body>

</html>