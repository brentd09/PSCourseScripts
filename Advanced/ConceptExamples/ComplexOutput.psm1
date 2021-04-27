function Get-DiceRollsRawData {
  Param(
    [int]$NumberOfFaces = 6,
    [int]$NumberOfDice = 2
  )
  [array]$DiceResults = 1..$NumberOfDice | ForEach-Object {1..$NumberOfFaces | Get-Random} 
  $NumberOfDice
  $NumberOfFaces
  $DiceResults
  ($DiceResults | Measure-Object -Sum).Sum
}

function Get-DiceRollsComplexObj {
  Param(
    [int]$NumberOfFaces = 6,
    [int]$NumberOfDice = 2
  )
  [array]$DiceResults = 1..$NumberOfDice | ForEach-Object {1..$NumberOfFaces | Get-Random} 
  $ObjProperties = [ordered]@{
    NumberOfDice = $NumberOfDice
    DiceFaces = $NumberOfFaces
    EachDiceRoll = $DiceResults
    SumOfFaces = ($DiceResults | Measure-Object -Sum).Sum
  }
  New-Object -TypeName psobject -Property $ObjProperties
}