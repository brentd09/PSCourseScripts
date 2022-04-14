class Animal {
  [int]$Legs
  [string]$Gender
  [string]$Living = $true

  Animal () {
    Write-Host -ForegroundColor Green "Animal Constructor"
  }

  Animal ([string]$Gender,[int]$Legs) {
    $this.Gender = $Gender
    $this.Legs = $Legs
  }
}

class Chicken : Animal {
  [double]$Wingspan

  Chicken () {
    Write-Host -ForegroundColor Red "Chicken Constructor"
  }

  Chicken ([double]$Wingspan,[string]$Gender) {
    $this.Wingspan = $Wingspan
    ([Animal]$this).Gender = $Gender
    ([Animal]$this).Legs = 2
  }
}

class Bantam : Chicken {
  [string]$Size

  Bantam ([double]$Wingspan,[string]$Gender,[string]$Size) {
    Write-Host -ForegroundColor Cyan "Bantam Constructor"
    $this.Size = $Size
    ([Animal]$this).Gender    = $Gender
    ([Chicken]$this).Wingspan = $Wingspan
    ([Chicken]$this).Legs     = 2 
  }
}

$Chicken = [Bantam]::New(10.3,'Male','Small')

$Chicken 