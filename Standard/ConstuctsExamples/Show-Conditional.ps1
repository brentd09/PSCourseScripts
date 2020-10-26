# If elseif else

[int]$Number = Read-Host -Prompt 'Please enter a number between 1 and 50'
if ($Number -gt 50 -or $Number -lt 1) {Write-Host "You typed in a number that was not between 1 and 50"}
elseif ($Number -le 25) {Write-Host 'You typed in a number between 1 and 25'}
else {write-host "You typed a number between 26 and 50"}

# menu using a switch statement

do {
  Write-Host "----MENU----"
  Write-Host
  Write-Host "1...Add User to AD"
  Write-Host "2...Delete User from AD"
  Write-Host "3...Change Users Password"
  Write-Host "4...Exit"
  Write-Host 
  $Choice = Read-Host -Prompt "Please enter your menu choice"
  switch ($Choice) {
    '1' {Write-Host "Adding a new user"}
    '2' {Write-Host "Deleting a user"}
    '3' {Write-Host "Changing the password"}
    '4' {Write-Host "Exiting from the menu"}
    Default {write-host "The menu you chose does not exist"}
  }
} until ($Choice -eq 4)

# menu using if statements

do {
  Write-Host "----MENU----"
  Write-Host
  Write-Host "1...Add User to AD"
  Write-Host "2...Delete User from AD"
  Write-Host "3...Change Users Password"
  Write-Host "4...Exit"
  Write-Host 
  $Choice = Read-Host -Prompt "Please enter your menu choice"
  if ($Choice -eq '1') {Write-Host "Adding a new user"}
  if ($Choice -eq '2') {Write-Host "Deleting a user"}
  if ($Choice -eq '3') {Write-Host "Changing the password"}
  if ($Choice -eq '4') {Write-Host "Exiting from the menu"}
  if ($Choice -ne '1' -and $Choice -ne '2' -and $Choice -ne '3' -and $Choice -ne '4') {write-host "The menu you chose does not exist"}
} until ($Choice -eq 4)