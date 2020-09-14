Get-IntuneApplication | Where isAssigned -eq $true | Select displayName,id | ForEach-Object {
    $app = $_.displayName
    Get-ApplicationAssignment -ApplicationId $_.id | ForEach-Object {
        $intent = $_.intent
        $type = $group = "Other"

        $od = "@odata.type"
        If ($_.target.$od -like "*exclusionGroupAssignmentTarget*") {
            $type = "Exclude"
            $group = (Get-AADGroup -Id $_.target.groupId).displayName
        } elseif ($_.target.$od -like "*groupAssignmentTarget*") {
            $type = "Include"
            $group = (Get-AADGroup -Id $_.target.groupId).displayName
        } elseif ($_.target.$od -like "*allLicensedUsers*") {
            $type = "Include"
            $group = "All Users"
        } elseif ($_.target.$od -like "*allDevices*") {
            $type = "Include"
            $group = "All Devices"
        }
        
        New-Object -TypeName PSObject -Property @{
            App = $app
            Intent = $intent
            Type = $type
            Group = $group
        } | Select-Object App,Intent,Type,Group
    } 
} | Export-CSV ./apps.csv