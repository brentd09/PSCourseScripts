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
  [psobject[]]$InputObject
)
Begin {}
Process {
  foreach ($Object in $InputObject) {
    $Object | Get-Member
  }
}
End {}
