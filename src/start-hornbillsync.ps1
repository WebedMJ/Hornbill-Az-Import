# Pass required json attributes as environment variables at container creation / run time
# e.g. on ACI see https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables
$HBDirectory = 'c:\Hornill_Import'
$HBConfig = Get-Content -Path C:\Hornbill_Import\conftemplate.json | ConvertFrom-Json
$HBConfig.AzureConf.Tenant = $env:AzureADTenant
#
# Add the other required secrets to conf from env...
#
$HBConfig | ConvertTo-Json -Depth 4 | Out-File $(Join-Path -Path $HBDirectory -ChildPath 'conf.json')
$params = @{
    FilePath         = '{0}\Azure2UserImport_amd64.exe' -f $HBDirectory
    WorkingDirectory = $HBDirectory
    ArgumentList     = '-dryrun=true'
}
Start-Process @params