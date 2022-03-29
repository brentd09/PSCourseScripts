
Class PolyGon {
  [int]$Sides
  [int]$SideLength
  
  PolyGon ($NumberOfSides,$LengthOfSide) {
    $this.SideLength = $LengthOfSide
    $this.Sides = $NumberOfSides
  }
  [double]Perimeter () {
    $Perim = $this.SideLength * $this.Sides
    return $Perim
  }
  [double]Area () {
    $MiddleAngle =  [math]::PI / $this.Sides 
    $Apothem = $this.SideLength / 2 / [math]::Tan($MiddleAngle)
    $Area = $this.Sides * $this.SideLength * $Apothem / 2
    return $Area
  }

  [double]InteriorAngles () {
    $CentreAngles = 360 / $this.Sides
    $InnerAngles = 180 - $CentreAngles
    return $InnerAngles
  }

  [void]UpdateValues ($NumberOfSides,$LengthOfSide) {
    $this.SideLength = $LengthOfSide
    $this.Sides = $NumberOfSides
  }
}


$Poly = [PolyGon]::New(8,20)
$Poly