class Circle {
  # Properties
  [double]$Radius
  [double]$Area
  [double]$Circumference
  # Methods
  [double]GetCircumference($Radius) {
    return ($Radius * 2 * [math]::pi)
  }
  [double]GetArea($Radius) {
    return ([math]::Pow($Radius,2) * [math]::PI)
  }
  # Constructors
  Circle () {
    $this.Radius = 1
    $this.Area = [math]::Pow(1,2) * [math]::PI
    $this.Circumference = 2 * [math]::PI * 1

  }

  Circle ([double]$Radius) {
    $this.Radius = $Radius
    $this.Area = [math]::Pow($Radius,2) * [math]::PI
    $this.Circumference = 2 * [math]::PI * $Radius
  }
}

# This shows how methods are used in the class
# this is a little redundant here as I have a constructor that builds the default 
# values for the same thing that the methods are getting, but its just an example!
Write-Host "Using constructor to build object"
$CircleInfo = New-Object -TypeName Circle -ArgumentList 3
$CircleInfo

$CircleInfo.GetArea(3)

$CircleInfo.GetCircumference(3)
