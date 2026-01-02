do {
  'Menu'
  Write-Host -ForegroundColor Yellow '1...Say hello'
  Write-Host -ForegroundColor Yellow '2...Say goodbye'
  Write-Host -ForegroundColor Yellow '3...Say nothing'
  Write-Host -ForegroundColor Yellow '9...Exit'
  $Choice = Read-Host -Prompt 'Enter a menu choice'
  switch ($Choice) {
    1 {Write-Host -ForegroundColor Yellow 'Hello'}
    2 {Write-Host -ForegroundColor Yellow 'Good-bye'}
    3 {Write-Host -ForegroundColor Yellow 'Nothing'}
    9 {}
    Default {Write-Host -ForegroundColor Yellow 'You chose a number that was not valid'}
  }
} Until ($Choice -eq 9)

Set-PSDebug -Trace 2 -Step

$EmailAddress = Read-Host -Prompt 'Enter an email address'
switch -wildcard ($EmailAddress) {
  'bob@*' {
    $MailBoxName = $EmailAddress.Substring(0,$EmailAddress.IndexOf('@'))
    Write-Host -ForegroundColor Yellow "Your mailbox name is $MailBoxName"
  }
  '*@adatum.com' {Write-Host -ForegroundColor Yellow 'You work for Adatum'}
  Default {Write-Host -ForegroundColor Yellow 'You have an email I do not recognise'}
}

Set-PSDebug -Off
