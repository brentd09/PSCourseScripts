[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$FileName
)

try {New-Item -Path $Path -Name $FileName -ItemType File -Value "This is a demo file" -ErrorAction Stop}
catch [System.IO.DirectoryNotFoundException]{Write-Warning -Message 'the path does not exist'}
catch [System.IO.IOException] {Write-Warning -Message 'The file cound not be written to the path, a duplicate filename may already exist'}
catch {Write-Warning -Message 'The file could not be created, unknown issue'}
