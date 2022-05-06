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
   
  if     ($AB.count -eq 0 -and $BA.count -eq 0) {$Result = 'Same'}
  elseif ($AB.count -eq 0 -and $BA.count -ne 0) {$Result = 'FirstSubset'}
  elseif ($AB.count -ne 0 -and $BA.count -eq 0) {$Result = 'SecondSubset'}
  elseif ($AB.count -ne 0 -and $BA.count -ne 0) {$Result = 'NotSame'}
  $ObjProperties = [ordered]@{
    FirstArray = $FirstArray
    SecondArray = $SecondArray
    Result = $Result
  }
  New-Object -TypeName psobject -Property $ObjProperties
}

function Compare-ArrayPair {
  [cmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [array]$ReferenceArray,
    [Parameter(Mandatory=$true)]
    [array]$DifferenceArray
  )

  # Show how A1 and A2 relate
  # -------------------------
  # Do R and D have the same elements
  # Do R and D have the same order and same elements
  # Subtract the elements of D from R
  # Intersection of R and D
  $SameValues = ($ReferenceArray | Where-Object {$_ -in $DifferenceArray}).Count -eq $ReferenceArray.count
  $Intersect  = $Intersect = $ReferenceArray | Where-Object {$_ -in $DifferenceArray}
  $SubtractDiff = $ReferenceArray | Where-Object {$_ -notin $DifferenceArray}
  if ($SameValues -eq $true) {
    $SameOrder = $true
    foreach ($Index in (0..($ReferenceArray.count - 1))) {
      $SameElementResult = $ReferenceArray[$Index] -eq $DifferenceArray[$Index]
      if ($SameElementResult -eq $false) {$SameOrder = $false; break}
    }
  }
  else {$SameOrder = $false}

  return [PSCustomObject][ordered]@{
    ArraysEqual = $SameValues
    SameOrder   = $SameOrder
    Difference  = $SubtractDiff
    Intersect   = $Intersect
  }
}

function Compare-TwoArray {  
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string[]]$Array1,
    [Parameter(Mandatory=$true)]
    [string[]]$Array2
  )
  $A1inA2    = @()
  $A1notinA2 = @()
  $A2inA1    = @()
  $A2notinA1 = @()
  
  foreach ($Array1Element in $Array1) {
    if ($Array1Element -in $Array2) {$A1inA2 += $Array1Element}
    else {$A1notinA2 += $Array1Element}
  }
  foreach ($Array2Element in $Array2) {
    if ($Array2Element -in $Array1) {$A2inA1 += $Array2Element}
    else {$A2notinA1 += $Array2Element}
  }
  $ObjHash = [ordered]@{
    Array1 = $Array1
    Array2 = $Array2
    ElementsCommon = $A1inA2
    UniqueToArray1 = $A1notinA2
    UniqueToArray2 = $A2notinA1
  }
  New-Object -TypeName psobject -Property $ObjHash
}

function Test-TwoArray {
  <#
.SYNOPSIS
  This tests to see if one array is equal to or a subset of another array
.DESCRIPTION
  This tests to see if one array is equal to or a subset of another array
.EXAMPLE
  Test-ArrayEqualorSubset -Array1 1,2,3 -Array2 1,2
  This will test which arrays are equal or subsets of the other
.NOTES
  General notes
  Created By: Brent Denny
  Created On: Long time ago
  Cleaned UP: 9-May-2019
#>
  [CmdletBinding()]
  Param (
    [int[]]$Array1 = @(1,2,3,5),
    [int[]]$Array2 = @(1,2,3)
  )
  $A1A2 = $Array1 | Where-Object {$_ -notin $Array2}
  $A2A1 = $Array2 | Where-Object {$_ -notin $Array1}
  
  if     ($A1A2.Count -eq 0 -and $A2A1.Count -eq 0) {'Array1 and Array2 arrays are the same'}
  elseif ($A1A2.Count -eq 0 -and $A2A1.Count -ne 0) {'Array1 is a subset of Array2'}
  elseif ($A1A2.Count -ne 0 -and $A2A1.Count -eq 0) {'Array2 is a subset of Aarray1'}
  elseif ($A1A2.Count -ne 0 -and $A2A1.Count -ne 0) {'Array1 and Array2 are not equal or subsets of each other'}
}