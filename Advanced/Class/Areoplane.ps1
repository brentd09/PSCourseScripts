class Aeroplane {
  [string]$Manufacturer
  [string]$MajorModel
  [string]$MinorModel
  [int]$EngineCount
  [string]$WingPosition
  [string]$PropulsionType
  [int]$MaxPassengerCount
  [string]$RegistraionNumber

  Aeroplane () {
    $this.Manufacturer = "Boeing"
    $this.MajorModel   = "737"
    $this.MinorModel   = "800"
    $this.EngineCount  = 2
    $this.WingPosition = "Low"
    $this.PropulsionType = "Jet"
    $this.MaxPassengerCount = 162
    $this.RegistraionNumber = "VH-YIE"
  }

  Aeroplane (  [string]$Manufacturer,  [string]$MajorModel,  [string]$MinorModel,  [int]$EngineCount,  [string]$WingPosition,  [string]$PropulsionType,  [int]$MaxPassengerCount,  [string]$RegistraionNumber) {
    $this.Manufacturer = $Manufacturer
    $this.MajorModel   = $MajorModel
    $this.MinorModel   = $MinorModel
    $this.EngineCount  = $EngineCount
    $this.WingPosition = $WingPosition
    $this.PropulsionType = $PropulsionType
    $this.MaxPassengerCount = $MaxPassengerCount
    $this.RegistraionNumber = $RegistraionNumber
  }

  [string]PullYoke () {
    return "The plane is ascending"
  }

  [string]PushYoke () {
    return "The plane is decending"
  }

  [string]TurnYokeClockwise () {
    return "The plane is turning right"
  }

  [string]TurnYokeAntiClockwise () {
    return "The plane is turning left"
  }

}

$BoeingJet = [Aeroplane]::new()
$BoeingJet

$AirbusJet = [Aeroplane]::new('Airbus','A320','200',2,'Low','Jet',157,'VA-WEZ')
$AirbusJet

$Cessna = [Aeroplane]::new('Cessna','172','',1,'High','Propeller',5,'F-HATZ')
$Cessna

$BoeingJet.TurnYokeAntiClockwise()