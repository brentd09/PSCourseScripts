[cmdletBinding()]
Param ([int]$MagazineCapacity = 17)

# Class
Class Glock {
  [string]$AmmoType
  [int] hidden $CartridgeCapacity
  [int]$LiveBulletsInCartridge
  [string]$FireAttempt
  [string]$Action

  Glock ($Capacity) {
    $this.AmmoType = '9mm'
    $this.CartridgeCapacity = $Capacity
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
    $this.Action = 'New'
  }

  [Glock]Reload () {
    $this.LiveBulletsInCartridge = $this.CartridgeCapacity
    $this.FireAttempt = "NA"
    $this.Action = 'Reload'
    return $this
  }

  [Glock]Fire () {
    if ($this.LiveBulletsInCartridge -ge 1) {
      $this.LiveBulletsInCartridge = $this.LiveBulletsInCartridge - 1
      $this.FireAttempt = "BANG"
      $this.Action = 'Fire'
      return $this
    }
    else {
      $this.FireAttempt = "CLICK"
      $this.Action = 'Fire'
      return $this
    }
  }

  [Glock]Status () {
    $this.FireAttempt = "NA"
    $this.Action = 'Status'
    return $this
  }

  [Glock]Unload () {
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
    $this.Action = 'Unload'
    return $this
  }
}


$HandGun = [Glock]::New($MagazineCapacity) 
$HandGun.Status()
$HandGun.Reload()
$HandGun.Fire()
$HandGun.Fire()
$HandGun.Unload() 
$HandGun.Fire() 
