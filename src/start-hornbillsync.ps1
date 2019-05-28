# WIP - Currently garbles API keys...
# TO-DO - Move to using Azure App Configuration
# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables
$HBDirectory = 'c:\Hornbill_Import'
$HBConfig = Get-Content -Path $HBDirectory\conftemplate.json | ConvertFrom-Json
$HBConfig.APIKey = $env:HBAPIKey
$HBConfig.InstanceId = $env:HBInstanceId
$HBConfig.AzureConf.Tenant = $env:AzureADTenant
$HBConfig.AzureConf.ClientID = $env:AzureADClientID
$HBConfig.AzureConf.ClientSecret = $env:AzureADClientSecret
($HBConfig.AzureConf.UsersByGroupID[0]).ObjectID = $env:AzureADGroupID1
($HBConfig.AzureConf.UsersByGroupID[0]).Name = $env:AzureADGroupName1
# ($HBConfig.AzureConf.UsersByGroupID[1]).ObjectID = $env:AzureADGroupID2
# ($HBConfig.AzureConf.UsersByGroupID[1]).Name = $env:AzureADGroupName2
$HBConfig | ConvertTo-Json -Depth 4 | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')
$params = @{
    FilePath         = '{0}\Azure2UserImport_x64.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    ArgumentList     = '-dryrun=true'
    Wait             = $true
}
Start-Process @params