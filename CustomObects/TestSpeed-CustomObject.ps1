$MaxNum = 5000

Write-Host -Foreground Yellow "Time to enumerate a $MaxNum element object collection using [PSObject]"
Measure-Command -Expression  {
  (0..$MaxNum) | ForEach-Object {
    [psobject]@{Name = "Test Name"; ID = $_}
  } 
} | Format-Table TotalSeconds -Autosize

Write-Host -Foreground Yellow "Time to enumerate a $MaxNum element object collection using [PSCustomObject]"
Measure-Command -Expression {
  (0..$MaxNum) | ForEach-Object {
    [pscustomobject]@{Name = "Test Name"; ID =$_}
  }
} | Format-Table TotalSeconds -Autosize
