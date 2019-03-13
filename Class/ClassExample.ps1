class Vehicle {
  [string]$Clasification
  [int]$NumberOfWheels
  [int]$NumberOfDoors
  [int]$YearOfCar
  [string]$ModelOfCar
  [string]$Type

  Vehicle ($NumberDoors,$Year,$Model,$Class) {
    $this.NumberOfWheels = 4
    $this.ModelOfCar = $Model
    $this.NumberOfDoors = $NumberDoors
    $this.YearOfCar = $Year
    $this.Clasification = $Class
    if ($Class -eq 'Car') {
      if ($NumberDoors -eq 4 ) {$this.Type = 'Sedan'}
      elseif ($NumberDoors -eq 2) {$this.Type = 'Coupe'}
    }
    elseif ($Class -eq 'Ute') {
      if ($NumberDoors -eq 4 ) {$this.Type = 'KingCab'}
      elseif ($NumberDoors -eq 2) {$this.Type = 'Cab'}
    }
    else {$this.Type = 'Unknown'}
  }
}



$CarObj = [Vehicle]::New(2,1990,'Holden','Car')
$UteObj = [Vehicle]::New(4,1990,'Holden','Ute')

$CarObj
$UteObj