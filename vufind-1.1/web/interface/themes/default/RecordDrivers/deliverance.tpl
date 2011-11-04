{literal}
        <script type="text/javascript" src="{/literal}{$url}{literal}/js/jquery-1.6.4.min.js"></script>

<script type="text/javascript">


var deliverance = "{/literal}{$deliverance}{literal}";
var pid = "{/literal}{$pid}{literal}";


$(document).ready(function() {
    $.ajax({
        url: deliverance+pid,
        success: success,
        dataType: "jsonp"
    });
});

function success(data) {
    $.each(data, function(record){
        alert(record);
    });
}


</script>

{/literal}