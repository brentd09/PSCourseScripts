class Engine {
  [string]$Type
  [int]$HorsePower

  Engine([string]$Type, [int]$HorsePower) {
    $this.Type = $Type
    $this.HorsePower = $HorsePower
  }
}

class Vehicle {
  [string]$Make
  [string]$Model
  [int]$Year
  [Engine]$Engine
  [int]$FuelRemaining
  

  Vehicle([string]$Make, [string]$Model, [int]$Year, [Engine]$Engine) {
    $this.Make   = $Make
    $this.Model  = $Model
    $this.Year   = $Year
    $this.Engine = $Engine
    $this.FuelRemaining = 0
  }

  [void]Refuel(){
    $this.FuelRemaining = 60
  }

  [void]Drive([int]$Distance) {
    if ($this.FuelRemaining -gt 0) {$this.FuelRemaining =  $this.FuelRemaining - (8 / 100 * $Distance)}
    if ($this.FuelRemaining -le 0) {$this.FuelRemaining = 0}
  }
}

$Donk = [Engine]::new("V4", 187)
$Car = [Vehicle]::new("Mazda", "CX5", 2023, $Donk)
$Car.Refuel()
$Car.Drive(100)
#$Car.Engine 
$Car