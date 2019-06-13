$Var = 10
While ($Var -lt 50) {
  $Var = $Var + 10
  $Var
}
Write-Host "Finished while Loop"

$Var = 10
do {
  $Var = $Var + 10
  $Var
} While ($Var -lt 50)
Write-Host "Finished do while Loop"

$Var = 10
do {
  $Var = $Var + 10
  $Var
} Until ($Var -gt 50)
Write-Host "Finished do until Loop"

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {continue}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach continue Loop"

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {break}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach break Loop"