<#PSScriptInfo

.VERSION 1.0

.GUID

.AUTHOR Tom Plant

.COMPANYNAME Ionize

.COPYRIGHT 

.TAGS Windows Autopilot

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
Version 1.0:  Original published version.
#>

<#
.SYNOPSIS
Registers the running Windows device in a Windows Autopilot registry

.DESCRIPTION
This script collects hardware information and imports it into the Windows Autopilot registry.
.EXAMPLE
powershell -ep Bypass .\Register-WindowsAutopilotDevice.ps1

#>

[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    [Parameter(Mandatory=$false)] [Switch] $Update = $false
)

Begin
{
    $repo = (New-Item -ItemType Directory -Force -Path 'Modules').FullName
    $env:PSModulePath += ";$repo"
    $module = Import-Module WindowsAutoPilotIntune -PassThru -ErrorAction Ignore

    # Get NuGet
    $provider = Get-PackageProvider NuGet -ErrorAction Ignore
    if (-not $provider) {
        Write-Host "Installing provider NuGet"
        Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies
    }
    
    if ($Update -or (-not $module)) {
        Write-Host "Installing dependencies"

        Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
        Find-Script -Name 'Get-WindowsAutoPilotInfo' | Save-Script -Path $repo
        Find-Module -Name 'WindowsAutopilotIntune' | Save-Module -Path $repo
        Set-PSRepository -Name "PSGallery" -InstallationPolicy 'Untrusted'

        Import-Module WindowsAutoPilotIntune
    }
}

Process
{
    try {
        & "$repo\Get-WindowsAutoPilotInfo.ps1" -Online
    } finally {
        Remove-Item "$([Environment]::GetFolderPath("MyDocuments"))\WindowsPowerShell" -Recurse
    }
}