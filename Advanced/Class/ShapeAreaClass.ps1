[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [double]$SideLength,
  [Parameter(Mandatory=$true)]
  [int]$NumberofEqualSides
)

Class AreaOfShape {
  [int]$NumberOfSides
  [double]$LenghOfSide
  [double]$TotalArea

  AreaOfShape([double]$Lengh,[int]$NumSides) {
    $this.LenghOfSide = $Lengh
    $this.NumberOfSides = $NumSides
    $this.TotalArea = [math]::Pow($Lengh / 2,2) * [math]::Tan((180 - (360 / $NumSides)) /2 * [math]::PI/180) * $NumSides 
  }
}

[AreaOfShape]::New($SideLength,$NumberofEqualSides)