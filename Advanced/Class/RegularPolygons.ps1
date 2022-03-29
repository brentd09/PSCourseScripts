
Class PolyGon {
  [int]$Sides
  [int]$SideLength
  
  PolyGon ($NumberOfSides,$LengthOfSide) {
    if ($NumberOfSides -lt 3) {
      Write-Warning "Not enough sides, must be at least three sides to be a polygon"
      break
    }
    else {
      $this.SideLength = $LengthOfSide
      $this.Sides = $NumberOfSides
    }
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

  [double]ExtrudedVolume ([double]$Height) {
    $Volume = $this.Area() * $Height
    return $Volume
  }

  [void]UpdateValues ($NumberOfSides,$LengthOfSide) {
    $this.SideLength = $LengthOfSide
    $this.Sides = $NumberOfSides
  }
}


$Poly = [PolyGon]::New(4,10)
$Poly