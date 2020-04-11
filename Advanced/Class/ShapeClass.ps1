[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [double]$SideLength,
  [Parameter(Mandatory=$true)]
  [int]$NumberofEqualSides
)

Class ShapeTool {

  ShapeTool() { }
  
  [double]FindArea([double]$Lengh,[int]$NumSides) {
    $TotalArea = [math]::Pow($Lengh / 2,2) * [math]::Tan((180 - (360 / $NumSides)) /2 * [math]::PI/180) * $NumSides 
    return $TotalArea
  }

  [double]FindPerimeter([double]$Lengh,[int]$NumSides) {
    $Perimeter = $Lengh * $NumSides
    return $Perimeter
  }
}

$Shape = [ShapeTool]::New()
$Shape.FindArea($SideLength,$NumberofEqualSides)
$Shape.FindPerimeter($SideLength,$NumberofEqualSides)