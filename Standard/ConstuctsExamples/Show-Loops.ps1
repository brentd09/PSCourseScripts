$Var = 10
While ($Var -lt 50) {
  $Var = $Var + 10
  $Var
}
Write-Host "Finished while Loop - test condition performed before loop runs"

$Var = 10
do {
  $Var = $Var + 10
  $Var
} While ($Var -lt 50)
Write-Host "Finished do while Loop - test condition performed after the loop"

$Var = 10
do {
  $Var = $Var + 10
  $Var
} Until ($Var -gt 50)
Write-Host "Finished do until Loop - condition needs to be the opposite to while to do the same thing"

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {continue}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach continue Loop - skipping bad numbers"

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {break}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach break Loop - when encountered bad number break out of loop"