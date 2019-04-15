[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$HB_SHA256 = "DBBDF4AF4ECC5DF1CADBDB8190160804DDB22830B1E32D215D6D03242AF65BA2"
$HB_VERSION = "1.4.2"
$HBDirectory = 'c:\Hornill_Import'
$params = @{
    Method  = 'Get'
    Uri     = 'https://github.com/hornbill/goAzure2HUserImport/releases/download/v{0}/Azure2UserImport_{1}.zip' -f $HB_VERSION, $HB_VERSION
    OutFile = 'c:\Azure2UserImport.zip'
}
Invoke-WebRequest @params
if ((Get-FileHash c:\Azure2UserImport.zip -Algorithm sha256).Hash -ne $HB_SHA256) { exit 1 }
Expand-Archive -Path c:\Azure2UserImport.zip -DestinationPath $HBDirectory
Remove-Item c:\Azure2UserImport.zip -Force
Remove-Item $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')