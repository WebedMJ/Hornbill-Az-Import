# Must run in PS 5 as Azure App Config REST API needs ',' in header
# ...which doesn't currently work in PS 6 Invoke-RESTMethod - 30/05/2019
#
# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables

$HBDirectory = 'c:\Hornbill_Import'
. $(Join-Path -Path $HBDirectory -ChildPath 'Get-AzureAppConfig.ps1')
(Get-AppConfigKeyValues -keyname $env:cfgkey).value | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')
$params = @{
    FilePath         = '{0}\Azure2UserImport_x64.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    ArgumentList     = '-dryrun=true' # remove or change to false to run for real
    Wait             = $true
}
Start-Process @params