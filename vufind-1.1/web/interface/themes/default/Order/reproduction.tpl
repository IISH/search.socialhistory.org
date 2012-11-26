<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="{$language}" xmlns="http://www.w3.org/1999/html">
<head>
    <title>{translate text='order'}</title>
{css media="screen" filename="styles.css"}
{css media="print" filename="print.css"}
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <script type="text/javascript" src="{$url}/js/jquery-1.6.4.min.js"></script>
    <script type="text/javascript">
        {literal}

        $(document).ready(function () {
            $("form").submit(function () {
                var missing = false;
                $(":input").each(function () {
                    if (this.value == "")
                        missing = true;
                })
                if (missing) {
                    alert("All fields are required for processing your order.");
                    return false;
                }
                return true;
            });
        });

        {/literal}
    </script>

<body style="text-align: left;padding: 5px;">

<div id="bd">
    <div id="yui-main" class="content">
        <div class="yui-b first">
            <div class="alignleft">
            {if $errorMsg}
                <div class="error">{$errorMsg|translate}</div>{/if}
            {if $infoMsg}
                <div class="userMsg">{$infoMsg|translate}</div>{/if}

                <p>{translate text="order.specify"}</p><p><a target="_blank"
                                                           href="{translate text='order.moreinfo1.href'}">{translate text='order.moreinfo1'}</a>
                                                    </p>

                <table style="background-color: #ffffff;">
                    <tr>
                        <td style="padding-right: 30px">
                            <form name="order" id="order" action="{$url}/Order/Email" method="POST">
                                <table>

                                    <tr>
                                        <td><strong><label for="email">{translate text='order.email'}:</label></strong>
                                        </td>
                                        <td><input type="text" name="email" size="40" id="email" value="{$email}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="fullname">{translate text='order.fullname'}
                                            :</label></strong></td>
                                        <td><input type="text" name="fullname" size="40" id="fullname"
                                                   value="{$fullname}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="address">{translate text='order.address'}
                                            :</label></strong></td>
                                        <td><textarea rows="4" cols="40" name="address" id="address"
                                                      value="{$address}"></textarea></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="zipcode">{translate text='order.zipcode'}
                                            :</label></strong></td>
                                        <td><input type="text" name="zipcode" size="40" id="zipcode"
                                                   value="{$zipcode}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="city">{translate text='order.city'}:</label></strong>
                                        </td>
                                        <td><input type="text" name="city" size="40" id="city" value="{$city}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="country">{translate text='order.country'}
                                            :</label></strong></td>
                                        <td><input type="text" name="country" size="40" id="country"
                                                   value="{$country}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="telephone">{translate text='order.telephone'}
                                            :</label></strong></td>
                                        <td><input type="text" name="telephone" size="40" id="telephone"
                                                   value="{$telephone}"/></td>
                                    </tr>
                                    <tr>
                                        <td><strong><label for="purpose">{translate text='order.purpose'}
                                            :</label></strong></td>
                                        <td><textarea rows="4" cols="40" name="purpose" id="purpose"
                                                      value="{$purpose}"></textarea></td>
                                    </tr>
                                </table>
                                <input type="hidden" name="title" id="title" value="{$coreShortTitle|escape}"/>
                            {foreach from=$coreHolding key=key item=value name=loop}
                                <input type="hidden" name="callnumber" id="callnumber" value="{$key|escape}"/>
                            {/foreach}

                                <input type="hidden" name="id" value="{$id}"/>
                                <input type="hidden" name="coreBarcode" id="coreBarcode" value="{$coreBarcode|escape}"/>
                                <input type="hidden" name="website" id="website"
                                       value="{$url|escape}/Record/{$id|escape}"/>
                                <input type="hidden" name="url" id="url" value="{$url|escape}/Order/Ordered"/>
                                <input type="submit" name="submit" value="{translate text='order.submit'}">
                            </form>
                        </td>
                        <td style="padding-left: 30px">
                            <div class="alignright"
                                 style="background-color: #ffffff;">{include file=$coreMetadata}</div>
                        </td>
                    </tr>
                </table>
                <p><a href="{translate text='order.moreinfo2.href'}"
                                                          target="_blank">{translate text='order.moreinfo2'}</a>)</p>

                <p>{translate text='order.moreinfo3'}</p>
            </div>


        </div>
    </div>
</div>

</body>
</html>
