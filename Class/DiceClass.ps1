Class Dice {
  [int]$Faces

  Dice ($DFaces) {
    $this.Faces = $DFaces
  }

  [int]Roll () {
    $RollValue = Get-Random -Maximum ($this.Faces + 1) -Minimum 1
    return $RollValue
  }
}

$DiceResult = [Dice]::New(6)
1..10 | ForEach-Object {
  $DiceResult.Roll() 
}