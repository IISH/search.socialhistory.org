{* This is a text-only email template; do not include HTML! *}

{translate text='order'}
{translate text='Title'}: {$title}
{translate text='Callnumbers'}: {$callnumbers}
{translate text='Barcode'}: {$coreBarcode}
{translate text='Download master from Sor'}: https://disseminate.objectrepository.org/file/master/10622/{$coreBarcode}?access_token={$orderAccess_token}&contentType=application/save
{translate text='Website'}: {$website}

{translate text="order.details"}:
{translate text="order.email"}: {$email}
{translate text="order.name"}: {$fullname}
{translate text="order.address"}: {$address}
{translate text="order.zipcode"}: {$zipcode}
{translate text="order.city"}: {$city}
{translate text="order.country"}: {$country}
{translate text="order.telephone"}: {$telephone}

{translate text="order.purpose"}: {$purpose}
