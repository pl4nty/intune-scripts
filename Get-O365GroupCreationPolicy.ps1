Connect-AzureAD

$setting = Get-AzureADDirectorySetting -All $True | where DisplayName -eq "Group.Unified" | select -exp Values

 | where {($_.Values | where Name -eq EnableGroupCreation).Value}

if (!$setting.Id) {
    Write-Host "Group creation is not restricted"
} elseif (($groupId = ($setting.Values | where Name -eq GroupCreationAllowedId).Value) -eq "") {
    Write-Host "Group creation is disabled"
    $groupId = 
    $group = Get-AzureADGroup -ObjectId 
    Write-Host "Group creation is restricted to members of "
}



$setting.EnableGroupCreation = $False
$setting.GroupCreationAllowedGroupId = If ($GroupName) {().ObjectId} Else {""}

Set-AzureADDirectorySetting -Id $setting.Id -DirectorySetting $setting