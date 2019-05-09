class Circle {
  [double]$Radius
  [double]$Circumference
  [double]$Area

  Circle ($Radius) {
    $this.Area = [math]::PI * [math]::Pow($Radius,2)
    $this.Circumference = 2 * [math]::PI * $Radius
    $this.Radius = $Radius
  }

  [double]ArcCircumference ($Angle) {
    [double]$Circ = $Angle / 360 * 2 * [math]::PI * $this.Radius
    return $Circ
  }

  [double]ArcArea ($Angle) {
    [double]$Circ = $Angle / 360 * [math]::PI * [math]::Pow($This.Radius,2)
    return $Circ
  }
}



$Angle = 90
$newCircle = [Circle]::New(15)
$ArcCirc = $newCircle.ArcCircumference($Angle)
$ArcArea = $newCircle.ArcArea($Angle)
"Arc Circumference = " + $ArcCirc
"Arc Area = " + $ArcArea