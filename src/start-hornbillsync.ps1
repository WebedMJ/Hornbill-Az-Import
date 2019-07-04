# Must run in PS 5 as Azure App Config REST API needs ',' in header
# ...which doesn't currently work in PS 6 Invoke-RESTMethod - 30/05/2019
#
# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$HBDirectory = 'c:\Hornbill_Import'
. $(Join-Path -Path $HBDirectory -ChildPath 'Get-AzureAppConfig.ps1')
$azfileaccount = (Get-AppConfigKeyValues -keyname 'azfileaccount').value
$azfileuser = (Get-AppConfigKeyValues -keyname 'azfileuser').value
$azfilepass = (Get-AppConfigKeyValues -keyname 'azfilepass').value
Invoke-Expression -Command "cmdkey /add:$azfileaccount.file.core.windows.net /user:$azfileuser /pass:$azfilepass"
New-PSDrive -Name L -PSProvider FileSystem -Root "\\$azfileaccount.file.core.windows.net\az2hblogs"
(Get-AppConfigKeyValues -keyname $env:cfgkey).value | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json') -Encoding ascii
$params = @{
    FilePath         = '{0}\azure_user_import.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    # ArgumentList     = '-dryrun=true' # remove or change to false to run for real
    Wait             = $true
}
Start-Process @params
# Cleanup conf
Remove-Item $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')
# Dump sync logs to container logs
Get-ChildItem -Path L:\* -Include '*.log' |
    Where-Object CreationTime -lt $(Get-Date).AddDays(-90) |
    Remove-Item -Force
$logs = Get-ChildItem -Path $(Join-Path -Path $HBDirectory -ChildPath 'log\*') -Include '*.log'
$logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Item | Copy-Item -Destination L:\ -Force