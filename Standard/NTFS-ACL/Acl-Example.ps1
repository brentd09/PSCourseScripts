$groupNameR = Get-ADGroup -Filter {<#Add your own filter#>}
$groupNameRW = Get-ADGroup -Filter {<#Add your own filter#>}
# Rights
$readOnly = [System.Security.AccessControl.FileSystemRights]"ReadAndExecute"
$readWrite = [System.Security.AccessControl.FileSystemRights]"Modify"
# Inheritance
$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
# Propagation
$propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
# User
$userRW = New-Object System.Security.Principal.NTAccount($groupNameRW)
$userR = New-Object System.Security.Principal.NTAccount($groupNameR)
# Type
$type = [System.Security.AccessControl.AccessControlType]::Allow
$accessControlEntryDefault = New-Object System.Security.AccessControl.FileSystemAccessRule @("Domain Users", $readOnly, $inheritanceFlag, $propagationFlag, $type)
$accessControlEntryRW = New-Object System.Security.AccessControl.FileSystemAccessRule @($userRW, $readWrite, $inheritanceFlag, $propagationFlag, $type)
$accessControlEntryR = New-Object System.Security.AccessControl.FileSystemAccessRule @($userR, $readOnly, $inheritanceFlag, $propagationFlag, $type)
$objACL = Get-ACL $newFolderFull
$objACL.RemoveAccessRuleAll($accessControlEntryDefault)
$objACL.AddAccessRule($accessControlEntryRW)
$objACL.AddAccessRule($accessControlEntryR)
Set-ACL $newFolderFull $objACL