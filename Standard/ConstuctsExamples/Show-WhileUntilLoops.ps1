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