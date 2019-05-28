[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$HBSHA256 = "CF98B8F47BE325524FD716520FA0CD3D765D453265BF5180330AF4ABBD92892F"
$HBVersion = "2.0.2"
$HBDirectory = 'c:\Hornbill_Import'
$HBZip = '{0}\Azure2UserImport.zip' -f $env:TEMP
$params = @{
    Method  = 'Get'
    Uri     = 'https://github.com/hornbill/goAzure2HUserImport/releases/download/v{0}/Azure2UserImport_{1}.zip' -f $HBVersion, $HBVersion
    OutFile = $HBZip
}
Invoke-WebRequest @params
if ((Get-FileHash $HBZip -Algorithm sha256).Hash -ne $HBSHA256) { exit 1 }
Expand-Archive -Path $HBZip -DestinationPath $HBDirectory
Remove-Item $HBZip -Force
Remove-Item $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')