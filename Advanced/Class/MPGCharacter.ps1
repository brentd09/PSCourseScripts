

class MPGPlayer {
  [string]$Name
  [string]$Gender
  [int]$Health
  [int]$Strength
  [int]$Stamina
  [int]$Hunger
  [int]$Armour
  [datetime]$WhenAte
  
  MPGPlayer ($PlayerName,$Gender,$Armour) {
    $this.Name = $PlayerName
    $this.Gender = $Gender
    $this.Health = 100
    $this.Strength = Get-Random -Minimum 60 -Maximum 101
    $this.Stamina = Get-Random -Minimum 60 -Maximum 80
    $this.Hunger = 0
    $this.Armour = $Armour
    $this.WhenAte = Get-Date
  }

  [void]DecStrength ([int]$StrReduce) {
    $this.Strength = $this.Strength - $StrReduce
    if ($this.Strength -lt 0) {$this.Strength = 0}
  }

  [void]IncrStrength ([int]$IncrReduce) {
    $this.Strength = $this.Strength + $IncrReduce
    if ($this.Strength -lt 100) {$this.Strength = 100}
  }

  [void]IncrHunger ([int]$IncrHunger) {
    $this.Hunger = $this.Hunger + $IncrHunger
    if ($this.Strength -gt 100) {$this.Hunger = 100}  
  }

  [void]DecHunger ([int]$DecHunger) {
    $this.Hunger = $this.Hunger - $DecHunger
    if ($this.Hunger -lt 0) {$this.Hunger = 0}  
  }

  [void]IncrHealth ([int]$IncrHealth) {
    $this.Health = $this.Health + $IncrHealth
    if ($this.Health -gt 100) {$this.Health = 100}  
  }

  [void]DecHealth ([int]$DecHealth) {
    $this.Health = $this.Health - $DecHealth
    if ($this.Health -lt 0) {$this.Health = 0}  
  }  

  [void]TakeHit ([int]$OpponentStrength) {
    $Variance = Get-Random -Minimum 0 -Maximum 21
    [int]$HitStrength = $OpponentStrength - (($this.Strength+$this.Health + $Variance) + ($this.Armour / 3))/3
    if ($HitStrength -lt 0) {$HitStrength = 0}
    $this.DecHealth($HitStrength) 

  }

  [MPGPlayer]CheckPlayer () {
    $CurrentDate = Get-Date
    $FoodTimeDiff = ($CurrentDate - $this.WhenAte).TotalMinutes 
    $this.IncrHunger(([int]($FoodTimeDiff * 3)))
    if ($this.Hunger -gt 80) {$this.DecStrength(3)}
    return $this
  }

  [void]EatFood ([int]$FoodSize) {
    $this.DecHunger($FoodSize)
    $this.Strength = $this.IncrStrength($FoodSize / 20)
  }

  [void]GetMedical () {
    $this.Health = 100
    $this.Hunger = 0
  }
}


#New Player
$Player1 = [MPGPlayer]::New('Brutus','Male',90)
$Player1.CheckPlayer()

#Ppponent hits player
$Player1.TakeHit(80)
$Player1.CheckPlayer()