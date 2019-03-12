class Vehicle {
  [string]$Clasification
  [int]$numberOfWheels
  [int]$numberOfDoors
  [int]$yearOfCar
  [string]$modelOfCar
  [string]$Type

  Vehicle ($NumberDoors,$Year,$Model,$Class) {
    $this.numberOfWheels = 4
    $this.modelOfCar = $Model
    $this.numberOfDoors = $NumberDoors
    $this.yearOfCar = $Year
    $this.Clasification = $Class
    if ($Class -eq 'Car') {
      if ($NumberDoors -eq 4 ) {$this.Type = 'Sedan'}
      elseif ($NumberDoors -eq 2) {$this.Type = 'Coupe'}
    }
    elseif ($Class -eq 'Ute') {
      if ($NumberDoors -eq 4 ) {$this.Type = 'KinCab'}
      elseif ($NumberDoors -eq 2) {$this.Type = 'Cab'}
    }
    else {$this.Type = 'Unknown'}
  }
}



$carObj = [Vehicle]::New(2,1990,'Holden','Car')
$UteObj = [Vehicle]::New(4,1990,'Holden','Ute')

$carObj
$UteObj