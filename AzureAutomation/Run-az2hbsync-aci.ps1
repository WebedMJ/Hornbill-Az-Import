<#

Requires AzureACIAuth and AzureACIREST modules - https://github.com/WebedMJ/PSAzureREST

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ContainerName,
    [Parameter(Mandatory = $false)]
    [array]$EnvironmentVariables,
    [Parameter(Mandatory = $true)]
    [string]$Image,
    [Parameter(Mandatory = $true)]
    [int16]$CPU,
    [Parameter(Mandatory = $true)]
    [string]$MemoryGB,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [Parameter(Mandatory = $true)]
    [ValidateSet('Linux', 'Windows')]
    [string]$OSType,
    [Parameter(Mandatory = $true)]
    [ValidateSet('Always', 'OnFailure', 'Never')]
    [string]$RestartPolicy,
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory = $false)]
    [bool]$ForceDelete = $false,
    [Parameter(Mandatory = $false)]
    $VerbosePreference = 'SilentlyContinue'
)

$acrloginserver = Get-AutomationVariable -Name 'acrloginserver'
$acruser = Get-AutomationVariable -Name 'acruser'
$acrpw = Get-AutomationVariable -Name 'acrpw' | ConvertTo-SecureString -AsPlainText -Force
$EnvironmentVariables = @(
    @{
        Name        = 'cfguri'
        secureValue = Get-AutomationVariable -Name 'cfguri'
    }
    @{
        Name        = 'cfgid'
        secureValue = Get-AutomationVariable -Name 'cfgid'
    }
    @{
        Name        = 'cfgsecret'
        secureValue = Get-AutomationVariable -Name 'cfgsecret'
    }
    @{
        Name        = 'cfgkey'
        secureValue = 'BasicUserSync'
    }
)

$params = @{
    SubscriptionId         = $SubscriptionId
    ResourceGroupName      = $ResourceGroupName
    AzureAutomationRunbook = $true
}
$cntgrps = Get-ACIContainerGroups @params
$containers = $cntgrps.value.properties.containers
if ($containers.name -icontains $ContainerName) {
    $CGExists = $true
    Write-Verbose "Found $ContainerName"
} else {
    $CGExists = $false
    Write-Verbose "Didn't find $ContainerName"
}

if ($CGExists) {
    if ($ForceDelete) {
        $params = @{
            Name                   = $ContainerName
            SubscriptionId         = $SubscriptionId
            ResourceGroupName      = $ResourceGroupName
            AzureAutomationRunbook = $true
        }
        Remove-ACIContainerGroup @params
    }
    $params = @{
        Name                   = $ContainerName
        SubscriptionId         = $SubscriptionId
        ResourceGroupName      = $ResourceGroupName
        AzureAutomationRunbook = $true
    }
    Start-ACIContainerGroup @params
} else {
    $params = @{
        Name                   = $ContainerName
        EnvironmentVariables   = $EnvironmentVariables
        Image                  = $Image
        CPU                    = $CPU
        MemoryGB               = $MemoryGB
        Location               = $Location
        OSType                 = $OSType
        RegistryServer         = $acrloginserver
        RegistryUser           = $acruser
        RegistryPassword       = $acrpw
        SubscriptionId         = $SubscriptionId
        ResourceGroupName      = $ResourceGroupName
        RestartPolicy          = $RestartPolicy
        AzureAutomationRunbook = $true
    }
    New-ACIContainerGroup @params
}