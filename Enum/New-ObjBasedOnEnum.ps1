enum PaintColor {
  Black  = 0
  Blue   = 1
  White  = 2
  Green  = 3
  Yellow = 4
  Red    = 5 
  Purple = 6
}

enum MakeName {
  Holden     = 0
  Ford       = 1
  Mazda      = 2
  Mitsubishi = 3
  Audi       = 4
  Hyundai    = 5
}

Class Car {
  [MakeName]$CarMake
  [string]$CarModel
  [PaintColor]$CarColor

  Car ($Make,$Model,$Color) {
    $this.CarColor = $Color
    $this.CarMake  = $Make
    $this.CarModel = $Model
  }
}

$CarObj = [Car]::New('Mazda','CX5','White')
$CarObj