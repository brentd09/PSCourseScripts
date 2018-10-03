class Car {
  static [int]$numberOfWheels = 4
  [int]$numberOfDoors
  [int]$yearOfCar
  [string]$modelOfCar
  [string]GetCarType ([int]$doors) {
    if ($doors -eq 2) {[string]$carType = "Coup"}
    else {[string]$carType = "Sedan"}
    return $carType
  }
}

class Ute {
  static [int]$numberOfWheels = 4
  [int]$numberOfDoors
  [Int]$yearOfCar
  [string]$modelOfCar
  [string]GetCarType () {
    if ($This.numberOfDoors -eq 2) {[string]$carType = "Cab"}
    else {[string]$carType = "Kingcab"}
    return $carType
  }
}

$carObj = New-Object -TypeName Car
$carObj.modelOfCar = 'holden'
$carObj.numberOfDoors = 2
$carObj.yearOfCar = 1990



$UteObj = New-Object -TypeName Ute
$UteObj.modelOfCar = 'holden'
$UteObj.numberOfDoors = 2
$UteObj.yearOfCar = 1990

Write-Host -ForegroundColor Yellow "Car type"
$carObj.GetCarType($carObj.numberOfDoors)
Write-Host -ForegroundColor Yellow "`nUte type"
$UteObj.GetCarType()