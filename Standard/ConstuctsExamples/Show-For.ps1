for ($i = 0; $i -le 10; $i++) {
  $i
}

# Lotto numbers the hard way
$PickNumersCount = 6
$LottoNumbers = @()
for ($i = 0; $i -le $PickNumersCount; $i++) {
  do {$Random = 1..45 | Get-Random}
  until ($Random -notin $LottoNumbers)
  $LottoNumbers += $Random
}
$LottoNumbers

# Lotto Numbers can be also done like this
1..45 | Get-Random -Count 6