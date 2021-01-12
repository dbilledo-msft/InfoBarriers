# Install-Module -Name  ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName admin@M365xXXXXXX.onmicrosoft.com

# Install-Module -Name Az
Import-Module -Name Az
Connect-AzAccount

$appId="bcf62038-e005-436d-b970-2a472f8c1982" 
$sp=Get-AzADServicePrincipal -ServicePrincipalName $appId
if ($sp -eq $null) { New-AzADServicePrincipal -ApplicationId $appId }
Start-Process  "https://login.microsoftonline.com/common/adminconsent?client_id=$appId"

# View existing Information Barrier Policy settings
Get-InformationBarrierPolicy

# Create Segments
New-OrganizationSegment -Name "Retail" -UserGroupFilter "Department -eq 'Retail'"
New-OrganizationSegment -Name "Marketing" -UserGroupFilter "Department -eq 'Marketing'"

#Create IB & activate
New-InformationBarrierPolicy -Name "Retail-to-Marketing" -AssignedSegment "Retail" -SegmentsBlocked "Marketing" -State Active
New-InformationBarrierPolicy -Name "Marketing-to-Retail" -AssignedSegment "Marketing" -SegmentsBlocked "Retail" -State Active

#Start IB policy engine
Start-InformationBarrierPoliciesApplication