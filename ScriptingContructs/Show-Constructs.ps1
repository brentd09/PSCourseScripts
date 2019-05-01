# 2 different types for foreach loops, the first version can created problems 
# when using nested foreach-object commands as both loops use $_

Get-Service | ForEach-Object {
  $_.Name
}

$Services = Get-service 
foreach ($service in $Services) {
  $Service.Name
}

# if constructs

$BitsService = Get-Service -Name BITS
if ($BitsService.Status -eq 'Stopped') {
  $BitsService | Start-Service
}

if ($BitsService.StartType -eq 'manual') {
  $BitsService | set-service -StartupType Automatic
}
elseif ($BitsService.StartType -eq 'disabled') {
  $BitsService | set-service -StartupType Manual
}
else {  $BitsService | set-service -StartupType Disabled}

# Switch constructs
switch ($BitsService.Name) {
  'Manual'   {$BitsService | set-service -StartupType Automatic}
  'Disabled' {$BitsService | set-service -StartupType Manual}
  Default    {$BitsService | set-service -StartupType Disabled}
}

# for construct 
for ($Number = 0; $Number -lt 10; $Number++) {
  write-host "This is line number $Number"
}

# While loops

$Value = 5
while ($Value -gt 1) {
  Write-Host $Value
  $Value--
}

$Value = 5
do {
  Write-Host $Value
  $Value--
} while ($Value -gt 1)

$Value = 5
do {
  Write-Host $Value
  $Value--
} until ($Value -le 1)

# Break and Continue
$Numbers = @(1,2,550,0,89,4,10,234)
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {continue}
  1024 / $number
}

$Numbers = @(1,2,550,0,89,4,10,234)
foreach ($Number in $Numbers) {
  if ($Number -eq 0) {break}
  1024 / $number
}