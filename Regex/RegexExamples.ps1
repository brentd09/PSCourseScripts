#Entering Cell phone info
$CellPhone = Read-Host -Prompt "Please enter your cell phone number"
#Check if Cell number was entered corrently 
#Numbers can be entered as 10 digits with or with out spaces (0432 213 123)
# OR
#Numbers can be entered with the country code eliminating the first number (+61 123 345 456)
if ($CellPhone -match "^(?:(?:\+(?:\d\s*){1,3}(?:\s*\d){9})|(?:(?:\s*\d){10}))$") {
  "Your number was entered correctly, now we will format it to our standard layout"
  if ($CellPhone -match "^(?:\d\s*){10}$") {
    $ProperlyFormatted = $CellPhone -replace "\s*",'' -replace "^((?:\d\s*){3})((?:\d\s*){4})((?:\d\s*){3})$",'$1 $2 $3'
  }
  elseif ($CellPhone -match "^\+(?:\d\s*){1,3}(?:\d\s*){9}") {
    $PlainNumber = $ProperlyFormatted = $CellPhone -replace "\s*",'' 
    $NumberSize = $PlainNumber.Length
    $CCodeLength = $NumberSize - 9
    $CCode = $PlainNumber.Substring(0,$CCodeLength)
    $PhoneNoCC = $PlainNumber.Substring($CCodeLength,$NumberSize-$CCodeLength)
    $ProperlyFormatted = $PlainNumber -replace "^(\w{\$CCodeLength})(\d{3})(\d{3})(\d{3})$",'$1 $2 $3 $4'
  }
  $ProperlyFormatted
}
else {"You did not enter the number corectly"}