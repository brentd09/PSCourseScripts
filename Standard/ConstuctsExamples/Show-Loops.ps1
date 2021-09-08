$Numbers = 12,6,3,4,0,16,72
foreach ($Number in $Numbers) {
  $Result = 144 / $Number
  "144 / $Number = $Result"
}
Write-host -ForegroundColor Yellow 'End of foreach with errors'

$Numbers = 12,6,3,4,0,16,72
foreach ($Number in $Numbers) {
  if ($Number -ne 0) {
    $Result = 144 / $Number
    "144 / $Number = $Result"
  }
}
Write-host -ForegroundColor Yellow 'End of foreach avoiding errors with if'

$Numbers = 12,6,3,4,0,16,72
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {continue}
  $Result = 144 / $Number
  "144 / $Number = $Result"
}
Write-host -ForegroundColor Yellow 'End of foreach avoiding errors with continue'

$Numbers = 12,6,3,4,0,16,72
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {break}
  $Result = 144 / $Number
  "144 / $Number = $Result"
}
Write-host -ForegroundColor Yellow 'End of foreach avoiding errors with break'

# While loops
$TestNumber = 1
while ($TestNumber -le 5) {
  $TestNumber
  $TestNumber = $TestNumber + 1
}
Write-host -ForegroundColor Yellow 'End of While loop - this may never execute the loop'

$TestNumber = 6
while ($TestNumber -le 5) {
  $TestNumber
  $TestNumber = $TestNumber + 1
}
Write-host -ForegroundColor Yellow 'End of While loop - this may never execute the loop'

# Do loops
$TestNumber = 1
do {
  $TestNumber
  $TestNumber = $TestNumber + 1
} while ($TestNumber -le 5)
Write-host -ForegroundColor Yellow 'End of Do-While loop - this will always perform at least one loop'

$TestNumber = 6
do {
  $TestNumber
  $TestNumber = $TestNumber + 1
} until ($TestNumber -gt 5)
Write-host -ForegroundColor Yellow 'End of Do-Until loop - this will always perform at least one loop'