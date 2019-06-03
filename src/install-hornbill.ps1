[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$HBSHA256 = "E49EDB3D020B3C132049DF0503F8DE41C702ABC256BDDB6B8BAFAA1417915179"
$HBuri = "https://github.com/hornbill/goAzure2HUserImport/releases/download/2.1.0/azure_user_import_win_x64_v2_1_0.zip"
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