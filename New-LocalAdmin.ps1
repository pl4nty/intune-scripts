# Install required Graph modules and connect with system cert
Install-Module Microsoft.Graph.Authentication
Install-Module Microsoft.Graph.DeviceManagement
# Connect-MgGraph -TenantId YOUR_TENANT_ID -ClientID YOUR_APP_ID -CertificateName YOUR_CERT_SUBJECT

# Get name of assigned user
$name = (Get-MgDeviceManagementManagedDevice -Filter "deviceName eq '$env:COMPUTERNAME'" -Top 1).userDisplayName
# $name = Read-Host "User display name"

# Set password
$password = ConvertTo-SecureString "yourpwhere" -AsPlainText -Force

$user = New-LocalUser -Name "$($name.Trim())-a" -FullName "$name Admin" -Description "Local administrative user for $name" -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $user
net user $user.Name /logonpasswordchg:yes