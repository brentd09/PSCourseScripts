Class Glock {
  [string]$AmmoType
  [int]$CartridgeCapacity
  [int]$LiveBulletsInCartridge
  [string]$FireAttempt

  Glock ($Capacity) {
    $this.AmmoType = '9mm'
    $this.CartridgeCapacity = $Capacity
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
  }

  [Glock]Reload () {
    $this.LiveBulletsInCartridge = $this.CartridgeCapacity
    $this.FireAttempt = "NA"
    return $this
  }

  [Glock]Fire () {
    if ($this.LiveBulletsInCartridge -ge 1) {
      $this.LiveBulletsInCartridge = $this.LiveBulletsInCartridge - 1
      $this.FireAttempt = "BANG"
      return $this
    }
    else {
      $this.FireAttempt = "CLICK"
      return $this
    }
  }

  [Glock]Status () {
    $this.FireAttempt = "NA"
    return $this
  }

  [Glock]Unload () {
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
    return $this
  }
}
do {
  $MagCap = Read-Host -Prompt "What is the Capacity of the magazine 17 or 19 bullets"
} until ($MagCap -in @('17','19'))

$HandGun = [Glock]::New($MagCap -as [int])
$HandGun.Status()
$HandGun.Reload()
$HandGun.Fire()
$HandGun.Fire()
$HandGun.Unload()
$HandGun.Fire()
