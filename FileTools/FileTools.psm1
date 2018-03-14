function Touch-File {
  [cmdletbinding()]
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$Filename
  )
  foreach ($file in $Filename ) {
    if (Test-Path $file) {
      (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else {
      $null > $file 
    }
  }
}