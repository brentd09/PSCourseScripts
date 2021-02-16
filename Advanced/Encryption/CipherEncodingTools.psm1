function ConvertTo-XOR {
  Param (
    [Parameter(Mandatory=$true)]
    [string]$PlainText,
    [Parameter(Mandatory=$true)]
    [string]$Key
  )
  $CypherText = ""
  $KeyPosition = 0
  $KeyArray = $Key.ToCharArray()
  $PlainText.ToCharArray() | foreach-object -process {
    $CypherText += [char]([byte][char]$_ -bxor $KeyArray[$keyposition])
    $KeyPosition += 1
    if ($KeyPosition -eq $key.Length) {$KeyPosition = 0}
  }
  return $CypherText
}

function ConvertTo-SHA265Hash {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$DataToBeHashed
  )
  New-Object System.Security.Cryptography.SHA256Managed | 
  ForEach-Object {
    $_.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($DataToBeHashed))
  } | ForEach-Object {$_.ToString("x2")} | Write-Host -NoNewline
  Write-Host
}