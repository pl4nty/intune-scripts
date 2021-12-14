$GroupName = Read-Host "Specify existing Azure AD group which will be allowed to create Office 365 Groups"

Connect-AzureAD

$setting = Get-AzureADDirectorySetting -All $true | where DisplayName -eq "Group.Unified"

if (!$setting.Id) {
    $template = Get-AzureADDirectorySettingTemplate | where DisplayName -eq "Group.Unified"
    $setting = New-AzureADDirectorySetting -DirectorySetting ($template.CreateDirectorySetting())
}

$setting.EnableGroupCreation = $False
$setting.GroupCreationAllowedGroupId = If ($GroupName) {(Get-AzureADGroup -SearchString $GroupName).ObjectId} Else {""}

Set-AzureADDirectorySetting -Id $setting.Id -DirectorySetting $setting