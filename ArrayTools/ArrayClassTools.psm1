function Compare-Array {
  <#
  .SYNOPSIS
    Compare two arrays
  .DESCRIPTION
    This script will compare two arrays and return an object that contains the two arrays
    and a result value:
    Result:
    0 - Both arrays are identical
    1 - The first array is a subset of the second
    2 - The second array is a subset of the first
    4 - Neither array is equal to or a subset of the other
  .EXAMPLE
    Compare-Array -FirstArray @(1,2,3) -SecondArray @(1,2)
    This will find that the second array is a subset of the first array
  .NOTES
    General notes
      Created by: Brent Denny
      Created on: 18 Apr 2019
  #>
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [array]$FirstArray,
    [Parameter(Mandatory=$true)]
    [array]$SecondArray
  )

  $AB = $FirstArray | Where-Object {$_ -notin $SecondArray}
  $BA = $SecondArray | Where-Object {$_ -notin $FirstArray}
   
  if     ($AB.count -eq 0 -and $BA.count -eq 0) {$Result = 0}
  elseif ($AB.count -eq 0 -and $BA.count -ne 0) {$Result = 1}
  elseif ($AB.count -ne 0 -and $BA.count -eq 0) {$Result = 2}
  elseif ($AB.count -ne 0 -and $BA.count -ne 0) {$Result = 4}
  $ObjProperties = [ordered]@{
    FirstArray = $FirstArray
    SecondArray = $SecondArray
    Result = $Result
  }
  New-Object -TypeName psobject -Property $ObjProperties
}