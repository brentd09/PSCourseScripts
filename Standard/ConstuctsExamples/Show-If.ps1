# if
$SpoolerService = Get-Service -Name Spooler
if ($SpoolerService.Status -eq 'Stopped') {
  $SpoolerService | Start-Service
  Write-Host -ForegroundColor Yellow 'Spooler service started'
}

# if else
$ServicesStarted = Get-Service | Where-Object {$_.Status -eq 'Running'}
if ($ServicesStarted.count -gt 20) {Write-Host -ForegroundColor Yellow 'There are more than 20 services started'}
else {Write-Host -ForegroundColor Yellow 'There are less than 21 services started'}

# if elseif else
$YearOfBirth = Read-host -Prompt 'What year were you born (find your generation name)'
if ($YearOfBirth -ge 1997 ) {Write-Host -ForegroundColor Yellow 'You are in the GenZ generation'}
elseif ($YearOfBirth -ge 1981 ) {Write-Host -ForegroundColor Yellow 'You are in the Millenial generation'}
elseif ($YearOfBirth -ge 1965 ) {Write-Host -ForegroundColor Yellow 'You are in the GenX generation'}
elseif ($YearOfBirth -ge 1955 ) {Write-Host -ForegroundColor Yellow 'You are in the Boomers2 generation'}
elseif ($YearOfBirth -ge 1946 ) {Write-Host -ForegroundColor Yellow 'You are in the Boomers1 generation'}
elseif ($YearOfBirth -ge 1928 ) {Write-Host -ForegroundColor Yellow 'You are in the PostWar generation'}
elseif ($YearOfBirth -ge 1922 ) {Write-Host -ForegroundColor Yellow 'You are in the WW2 generation'}
else {Write-Host -ForegroundColor Yellow 'You are in an unknown generation'}
