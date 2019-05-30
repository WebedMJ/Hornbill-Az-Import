<#
ONLY WORKS IN Windows PS 5.x NOT Core/6.x (╯°□°）╯︵ ┻━┻
6.x Invoke-RestMethod doesn't like commas in the authorization header...

Defaults to getting Azure App Config details from env vars:
$env:cfguri
$env:cfgid
$env:cfgsecret
#>
function Get-AppConfigKeyValues {
    param (
        [Parameter(Mandatory = $false)]
        [uri]$uri = $env:cfguri,
        [Parameter(Mandatory = $false)]
        [string]$id = $env:cfgid,
        [Parameter(Mandatory = $false)]
        [string]$secret = $env:cfgsecret,
        [Parameter(Mandatory = $false)]
        [string]$keyname
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if (!$uri -or !$id -or !$secret) {
        throw 'Missing Azure App Config details'
    }
    if ($keyname) {
        $keyquery = 'kv/{0}' -f $keyname
    } else {
        $keyquery = 'kv'
    }
    $appcfguri = [System.UriBuilder]::new($uri.Scheme, $uri.Host, "443", $keyquery, '?$select=key,value')
    $body = ''
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $sha256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
    $bodyhash = [Convert]::ToBase64String($sha256.ComputeHash([Text.Encoding]::ASCII.GetBytes($body)))
    $signedheaders = 'Host;x-ms-date;x-ms-content-sha256'
    $signedheadersvalue = '{0};{1};{2}' -f $uri.Host, $GMTTime, $bodyhash
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($secret)
    $urimethod = 'GET'
    $StringToSign = "{0}`n{1}`n{2}" -f $urimethod, $appcfguri.Uri.PathAndQuery, $signedheadersvalue
    $signature = [Convert]::ToBase64String($hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($StringToSign)))
    $Authorization = "HMAC-SHA256 Credential={0},SignedHeaders={1},Signature={2}" -f $id, $signedheaders, $signature
    $headers = @{
        Host                  = $uri.Host
        'x-ms-date'           = $GMTTime
        'x-ms-content-sha256' = $bodyhash
        Authorization         = $Authorization
    }
    $r = Invoke-RestMethod -Uri $appcfguri.Uri -Headers $headers -Method $urimethod
    return $r
}