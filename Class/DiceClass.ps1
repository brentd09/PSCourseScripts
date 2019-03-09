﻿Class Dice {
  [int]$Count
  [int]$Faces

  Dice ($DCount,$DFaces,$DWeight) {
    $this.Count = $DCount
    $this.Faces = $DFaces
  }

  [psobject]Roll () {
    $DieFaces = @()
    $AddedFaces = 0
    1..$this.Count | ForEach-Object {
      $RollValue = Get-Random -Maximum ($this.Faces + 1) -Minimum 1
      $DieFaces += $RollValue
      $AddedFaces = $AddedFaces + $RollValue
    }
    $objProp = [ordered]@{
      Faces = $DieFaces
      Total = $AddedFaces
    }
    return (New-object -TypeName psobject -Property $objProp)
  }
}

$DiceResult = [Dice]::New(2,6)
1..10 | ForEach-Object {
  $DiceResult.Roll() 
}| Get-Random