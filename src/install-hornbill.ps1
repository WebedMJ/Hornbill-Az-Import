[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$HBSHA256 = "E8A599FE2872F604EAED192F6212D8300848FF1B0B2AFB8E9E1F889972265B3B"
$HBuri = "https://github.com/hornbill/goAzure2HUserImport/releases/download/2.2.1/azure_user_import_win_x64_v2_2_1.zip"
$HBDirectory = 'c:\Hornbill_Import'
$HBZip = '{0}\Azure2UserImport.zip' -f $env:TEMP
$params = @{
    Method  = 'Get'
    Uri     = $HBuri
    OutFile = $HBZip
}
Invoke-WebRequest @params
if ((Get-FileHash $HBZip -Algorithm sha256).Hash -ne $HBSHA256) { exit 1 }
Expand-Archive -Path $HBZip -DestinationPath $HBDirectory
Remove-Item $HBZip -Force
Remove-Item $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')