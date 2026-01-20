function Set-NtfsAcl {
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
    $ADUser = Get-ADUser -Identity $Identity -ErrorAction stop
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
