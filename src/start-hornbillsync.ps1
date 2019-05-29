# Must run in PS 6 as it garbles API keys in PS 5...
# WIP - Move to using Azure App Configuration
# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables
$HBDirectory = 'c:\Hornbill_Import'
$appconfig = .\Get-AzureAppConfig.ps1
$HBConfig = Get-Content -Path $HBDirectory\conftemplate.json | ConvertFrom-Json
[uri]$configuri = $env:cfguri # move to appconfig script to run in ps 5
$configid = $env:cfgid # move to appconfig script to run in ps 5
$configsecret = $env:cfgsecret # move to appconfig script to run in ps 5

# TO DO
# Need to modify script to get environment vars within PS 5 process to save passing them through here (uri, id, secret)
$HBConfig.APIKey = (
    powershell.exe -noprofile -Command {
        . .\Get-AzureAppConfig.ps1;
        (Get-AppConfigKeyValues -uri 'xx' -id 'xx' -secret 'xx' -keyname 'APIKey').value })
# $HBConfig.InstanceId = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'InstanceId').value
# $HBConfig.AzureConf.Tenant = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.Tenant').value
# $HBConfig.AzureConf.ClientID = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.ClientID').value
# $HBConfig.AzureConf.ClientSecret = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.ClientSecret').value
# ($HBConfig.AzureConf.UsersByGroupID[0]).ObjectID = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.UsersByGroupID.0.ObjectID').value
# ($HBConfig.AzureConf.UsersByGroupID[0]).Name = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.UsersByGroupID.0.Name').value
# ($HBConfig.AzureConf.debug = (
#     Get-AppConfigKeyValues -uri $configuri -id $configid -secret $configsecret -keyname 'AzureConf.debug').value

# This line only works in PS 6... https://github.com/PowerShell/PowerShell/issues/2632
$HBConfig | ConvertTo-Json -Depth 4 | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')
$params = @{
    FilePath         = '{0}\Azure2UserImport_x64.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    ArgumentList     = '-dryrun=true' # remove or change to false to run for real
    Wait             = $true
}
Start-Process @params