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

<#
This is a simpler way if you just need to test for one array being a subset of another

$Large = 1,2,3,5,6,7,8,9

$Small1 = 2,3,4

$Small2 = 1,5,9

if (-not [bool]( $Small1 | Where-Object {$_ -notin $Large}).count) {"Its a subset"} else {"its not a subset"}
if (-not [bool]( $Small2 | Where-Object {$_ -notin $Large}).count) {"Its a subset"} else {"its not a subset"}
#>
