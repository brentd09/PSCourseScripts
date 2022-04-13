function Convert-ObjectToHashTable {
  [CmdletBinding()]
  Param (
    [PSObject]$PowerShellObject
  )
  if ($PowerShellObject.Count -gt 1) {$PSObj = $PowerShellObject[0]}
  else {$PSObj = $PowerShellObject}
  $NewHashTab = @{}
  $Properties = $PSObj | Get-Member -MemberType Properties
  foreach ($Property in $Properties) {
    $PropName = $Property.Name
    if ($Property.MemberType -eq 'Property') { $PropType = ($Property.Definition -split '\s+')[0] }
    elseif ($Property.MemberType -eq 'AliasProperty') {
      $ParentProperyName = ($Property.Definition -split '\s+')[-1]
      $ParentPropery | Where-Object {$_.Name -eq $ParentProperyName}
      $PropType = ($ParentPropery.Definition -split '\s+')[0]
    }
    $PropertyObj = $PSObj.($PropName)
    $NewHashTab.Add($Property.Name,$PropertyObj )
  }
  return $NewHashTab
}

