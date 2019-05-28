<#
ONLY WORKS IN Windows PS NOT Core/6.x (╯°□°）╯︵ ┻━┻
6.x Invoke-RestMethod doesn't like commas in the authorization header...

Host: example.azconfig.io
Date: Fri, 11 May 2018 18:48:36 GMT
x-ms-content-sha256: 47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=
Authorization: HMAC-SHA256 Credential=a4016f0fa8fb0ef2, SignedHeaders=Host;x-ms-date;x-ms-content-sha256, Signature=jMXmttaxBJ0NmLlFKLZUkI8jdFu/8yqcTYzbkI3DGdU=

x-ms-content-sha256	base64 encoded SHA256 hash of the request body. It must be provided even of there is no body. base64_encode(SHA256(body))

string-To-Sign=
            "GET" + '\n' +                                                                                      // VERB
            "/kv?fields=*" + '\n' +                                                                             // path_and_query
            "Fri, 11 May 2018 18:48:36 GMT;example.azconfig.io;47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="    // signed_headers_values

https://github.com/Azure/AppConfiguration/blob/master/docs/REST/authentication.md
/#>

# [string]$appconf = 'https://example.azconfig.io;Id=xxxxxxxxxxxxxx;Secret=xxxxxxxxxxxxxxxxxxxxxxxx'
# [uri]$hosturi = $appconf.Split(';')[0]
# [string]$credential = (($appconf.Split(';')[1]).Substring(3)).Split(':')[1]
# # [string]$credential = (($appconf.Split(';')[1]).Substring(3))
# $configuri = [System.UriBuilder]::new($hosturi.Scheme, $hosturi.Host, "443", 'keys', '')
[uri]$configuri = 'https://example.azconfig.io'
$configid = 'xxxx'
$configsecret = 'xxxx'

$uri = [System.UriBuilder]::new($configuri.Scheme, $configuri.Host, "443", 'kv', '?$select=key,value')
$body = ''
$GMTTime = (Get-Date).ToUniversalTime().toString('R')
$sha256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
$bodyhash = [Convert]::ToBase64String($sha256.ComputeHash([Text.Encoding]::ASCII.GetBytes($body)))
$signedheaders = 'Host;x-ms-date;x-ms-content-sha256'
$signedheadersvalue = '{0};{1};{2}' -f $configuri.Host, $GMTTime, $bodyhash
# $b64secret = ($appconf.Split(';')[2]).Substring(7)
$hmacsha = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha.key = [Convert]::FromBase64String($configsecret)
$urimethod = 'GET'
$StringToSign = "{0}`n{1}`n{2}" -f $urimethod, $uri.Uri.PathAndQuery, $signedheadersvalue
$signature = [Convert]::ToBase64String($hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($StringToSign)))
# $Authorization = 'HMAC-SHA256 Credential={0}, SignedHeaders={1}, Signature={2}' -f $configid, $signedheaders, $signature
$Authorization = "HMAC-SHA256 Credential={0}, SignedHeaders={1}, Signature={2}" -f $configid, $signedheaders, $signature
$headers = @{
    Host                  = $configuri.Host
    'x-ms-date'           = $GMTTime
    'x-ms-content-sha256' = $bodyhash
    Authorization         = $Authorization
}
$r = Invoke-RestMethod -Uri $uri.Uri -Headers $headers -Method $urimethod

$error[0].Exception.Response.Headers
