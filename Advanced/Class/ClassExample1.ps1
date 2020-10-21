class Vehicle {
  [string]$Clasification
  [int]$NumberOfWheels
  [int]$NumberOfDoors
  [int]$YearOfCar
  [string]$MakeOfCar
  [string]$Type

  Vehicle ($NumberDoors,$Year,$Model,$Class) {
    $this.NumberOfWheels = 4
    $this.MakeOfCar = $Model
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


[vehicle[]]$CarObj = $null
[vehicle[]]$CarObj += [Vehicle]::New(2,1990,'Holden','Car')
$CarObj += [Vehicle]::New(4,1990,'Holden','CrossOver')
$CarObj += [Vehicle]::New(4,1990,'Holden','Ute')

$CarObj | ft
