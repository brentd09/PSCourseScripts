class Car {
  [string]$Model
  [string]$Make
  [int]$Year
  [int]$Doors
  [string]$CarType
  hidden [string]$FuelType = "Petrol"
  static [boolean]$Lights = $true

  #Constructors (They must use the same name as the object otherwise they would be seen as a method declaration)
  Car ([string]$Make,[string]$Model,[int]$Year,[int]$Doors) {
    $this.Model = $Model
    $this.Make = $Make
    $this.Year = $Year
    $this.Doors = $Doors
    # The constructor can use code to manipulate the default values of the instantiated object
    # $this is referring to the instantiated object, not this class.
    if ($Doors -eq 4 ) {$this.CarType = "Sedan"}
    elseif ($Doors -eq 2 ) {$this.CarType = "Coupe"}
    else {$this.CarType = "Unknown"}
  }
}

#The New() below is a Method that is built with all new objects in PowerShell
#This next line will work as there is an overload constructor for this with 4 parameters
$newCar = [Car]::New("Holden","HR",1967,2)
# You could also use the New-Object command to instantiate the object as below
# $newCar = New-Object -TypeName Car -ArgumentList "Holden","HR",1967,4

#The next line would fail as there is no overload constructor with only 3 parameters
# $newCar = [Car]::New("Holden","HR",1967)

$newCar

# The hidden property can be retrieved by $newCar.FuelType
$newCar.FuelType

# The static property can only be seen by $newCar::Lights
$newCar::Lights
