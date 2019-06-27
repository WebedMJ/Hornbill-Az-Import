[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$HBSHA256 = "59304AF3C7ED36FEC3B9899C9439FB224C4A876419C959A7B89C8D019C094832"
$HBuri = "https://github.com/hornbill/goAzure2HUserImport/releases/download/2.1.1/azure_user_import_win_x64_v2_1_1.zip"
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