'Menu'
Write-Host -ForegroundColor Yellow '1...Say hello'
Write-Host -ForegroundColor Yellow '2...Say goodbye'
Write-Host -ForegroundColor Yellow '3...Say nothing'
$Choice = Read-Host -Prompt 'Enter a menu choice'
switch ($Choice) {
  1 {'Hello'}
  2 {'Good-bye'}
  3 {'Nothing'}
  Default {'You chose a number that was not valid'}
}


$EmailAddress = Read-Host -Prompt 'Enter an email address'
switch -wildcard ($EmailAddress) {
  'bob@*' {
    $MailBoxName = $EmailAddress.Substring(0,$EmailAddress.IndexOf('@'))
    "Your mailbox name is $MailBoxName"
  }
  '*@adatum.com' {'You work for Adatum'}
  Default {'You have an email I do not recognise'}
}