function Show-PropertyTree {
  <#
    .SYNOPSIS
      Short description
    .DESCRIPTION
      Long description
    .EXAMPLE
      PS C:\> <example usage>
      Explanation of what the example does
    .INPUTS
      Inputs (if any)
    .OUTPUTS
      Output (if any)
    .NOTES
      General notes
  #>
  [CmdletBinding()]
  Param (
    [Parameter(ValueFromPipeline)]
    [psobject]$InputObject
  )
 
  Begin {
    $TypeNameArray = @()
    $PropertyArray = @()
  }
  Process {
    $PropMembers = $InputObject | Get-Member -MemberType Properties
    $TypeName = $PropMembers.TypeName | Get-Unique
    if ($TypeName -notin $TypeNameArray) {
      $TypeNameArray += $TypeName
      $PropertyArray += $PropMembers
    }
  }  
  End {$TypeNameArray}
}
