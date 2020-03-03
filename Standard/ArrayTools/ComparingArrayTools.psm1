function Compare-Arrays {  
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
