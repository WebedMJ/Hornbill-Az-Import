# Must run in PS 5 as Azure App Config REST API needs ',' in header
# ...which doesn't currently work in PS 6 Invoke-RESTMethod - 30/05/2019
#
# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$HBDirectory = 'c:\Hornbill_Import'
. $(Join-Path -Path $HBDirectory -ChildPath 'Get-AzureAppConfig.ps1')
(Get-AppConfigKeyValues -keyname $env:cfgkey).value | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json') -Encoding ascii
$params = @{
    FilePath         = '{0}\azure_user_import.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    # ArgumentList     = '-dryrun=true' # remove or change to false to run for real
    Wait             = $true
}
Start-Process @params
# Dump sync logs to container logs
$logs = Get-ChildItem -Path $(Join-Path -Path $HBDirectory -ChildPath 'log\*') -Include '*.log'
$logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content