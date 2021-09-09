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