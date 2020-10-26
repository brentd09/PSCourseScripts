# While loops

$Var = 10
While ($Var -lt 50) {
  $Var = $Var + 10
  $Var
}
Write-Host "Finished while Loop - test condition performed before loop runs"

$Var = 60
While ($Var -lt 50) {
  $Var = $Var + 10
  $Var
}
Write-Host "Finished while Loop - test condition performed before loop runs"

# Do While loops

$Var = 10
do {
  $Var = $Var + 10
  $Var
} While ($Var -lt 50)
Write-Host "Finished do while Loop - test condition performed after the loop"

$Var = 60
do {
  $Var = $Var + 10
  $Var
} While ($Var -lt 50)
Write-Host "Finished do while Loop - test condition performed after the loop"

# Do Until loops

$Var = 10
do {
  $Var = $Var + 10
  $Var
} Until ($Var -gt 50)
Write-Host "Finished do until Loop - condition opposite to while loops"

# foreach loop with a divide by zero issue

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach continue Loop - math errors apparent"

# foreach loop with continue

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {continue}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach continue Loop - skipping bad number"

# foreach loop with break

$Numbers = 12,14,16,2,0,13,17
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {break}
  $Answer = 144 / $Number
  $Answer
}
Write-Host "Finished foreach break Loop - when encountered bad number breaks out of loop"