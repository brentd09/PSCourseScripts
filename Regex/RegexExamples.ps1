Class MobilePhone {
  [string]$Number

  MobilePhone ([string]$CellNumber) {
    if ($CellNumber -match "^(?:(?:\+(?:\d\s*){1,3}(?:\s*\d){9})|(?:(?:\s*\d){10}))$") {
      if ($CellNumber -match "^(?:\d\s*){10}$") {
        [string]$ProperlyFormatted = $CellNumber -replace "\s*",'' -replace "^((?:\d\s*){3})((?:\d\s*){4})((?:\d\s*){3})$",'$1 $2 $3'
      }
      elseif ($CellNumber -match "^\+(?:\d\s*){1,3}(?:\d\s*){9}") {
        $PlainNumber = $ProperlyFormatted = $CellNumber -replace "\s*",'' 
        $NumberSize = $PlainNumber.Length
        $CCodeLength = $NumberSize - 9
        $CCode = $PlainNumber.Substring(0,$CCodeLength)
        $PhoneNoCC = $PlainNumber.Substring($CCodeLength,$NumberSize-$CCodeLength)
        [string]$ProperlyFormatted = $CCode + " " + ($PhoneNoCC -replace "(\d{3})(\d{3})(\d{3})",'$1 $2 $3')
      }
      $this.Number = $ProperlyFormatted
    }
    else {throw "The number entered does not conform to Australian mobile standards"}
  }
}

$NewNumber = [MobilePhone]::New('+61432123111')
$NewNumber