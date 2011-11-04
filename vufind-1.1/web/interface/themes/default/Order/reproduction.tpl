<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="{$language}">
<head>
    <title>{translate text='order'}</title>
{css media="screen" filename="styles.css"}
{css media="print" filename="print.css"}
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <script type="text/javascript" src="{$url}/js/jquery-1.6.4.min.js"></script>
<script type="text/javascript">
{literal}
        $("orderForm").submit(function(){

        $(".required").each(function(){
            if ( this.value == "" ){
                alert("All fields are required for processing your order.");
}
            });
        {/literal}

{if $errorMsg}
                <div class="error">{$errorMsg|translate}</div>{/if}
{if $infoMsg}
                <div class="userMsg">{$infoMsg|translate}</div>{/if}

{translate text="order.specify"}

{$url}

{translate text='order.rates'}
{if $language=='nl'}<a target="_blank" href="http://www.iisg.nl/rates-nl.php">http://www.iisg.nl/rates-nl.php</a>
                        {else}
                            <a target="_blank" href="http://www.iisg.nl/rates.php">http://www.iisg.nl/rates.php</a>{/if}


{translate text='order.email'}



{translate text='order.fullname'}



{translate text='order.address'}



{translate text='order.zipcode'}



{translate text='order.city'}



{translate text='order.country'}



{translate text='order.telephone'}



{translate text='order.purpose'}



{$coreShortTitle|escape}
{foreach from=$coreHolding key=key item=value name=loop}
                    <input type="hidden" name="callnumber" id="callnumber" value="{$key|escape}"/>
                {/foreach}

{$coreBarcode|escape}
{$url|escape}        {$id|escape}
{$url|escape}
{translate text='Send order'}




{include file=$coreMetadata}</div>
        </div>
    </div>

</body>
</html>