function Set-NtfsAcl {
  <#
  .SYNOPSIS
    Sets NTFS permissions on a specified directory
  .DESCRIPTION
    This cmdlet gets the current ACL from the specified directory and adds the permissions 
    to the existing ones before reseting the ACL on the path 
  .PARAMETER Path
    specifies the path that will have the ACL set
  .PARAMETER Identity
    Identifies the Active Directory identity to configure the permissions for
  .PARAMETER Permission
    Specifies which permissions will be given to the identity
  .PARAMETER Inheritance
    Set to NONE by default, however you can set the inheritance flags if desired
  .PARAMETER Propagation
    Set to NONE by default, but this can also be configured if needed
  .PARAMETER RuleType
    Set to ALLOW by default, this sets the rule as an allow of deny rule        
  .NOTES
    Created by: Brent Denny
    Created on: 20-Jan-2026
      Change Log:
      -----------
      20-Jan-2026 - added the help content
  .EXAMPLE
    Set-NtfsAcl -Path e:\test -Identity Adatum\Ida -Permission FullControl 
    This adds Ida having FullControl to the path e:\test.
  #>
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [string]$Identity,

    [Parameter(Mandatory=$true)]
    [validateset('FullControl', 'Modify', 'ReadAndExecute','ListFolderContents', 'Read', 'Write')]
    [string]$Permission,

    [validateset('None','ContainerInherit','ObjectInherit')]
    [string]$Inheritance = 'none',

    [validateset('None','InheritOnly')]
    [string]$Propagation = 'none',

    [validateset('allow','deny')]
    [string]$RuleType = 'allow'
  )

  try {
    Get-ADUser -Identity $Identity -ErrorAction stop *> $null
  }
  catch {
    Write-Warning "Identity not found in ActiveDirectory"
    break
  }
  if ((Test-Path $Path) -eq $false) {
    Write-Warning 'The path is not found'
    break
  }
   
  $AclRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
    $Identity,
    $Permission,
    $Inheritance,
    $Propagation,
    $RuleType
  )
  $ACL = get-acl -Path $Path
  $ACL.SetAccessRule($AclRule)
  Set-Acl -Path $Path -AclObject $ACL
}
