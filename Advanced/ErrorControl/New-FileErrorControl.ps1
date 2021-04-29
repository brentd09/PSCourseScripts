[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$FileName
)

<#
  To produce the Catch blocks below:
  1. Force the error to happen
  2. Use $Error[0].Exception.GetType().FullName to find the error object type
  3. Place the fullname of the exception in the [] after the catch statement
  
  The last catch will catch all other errors that have not filtered out by previous catch blocks
#>


try {New-Item -Path $Path -Name $FileName -ItemType File -Value "This is a demo file" -ErrorAction Stop}
catch [System.IO.DirectoryNotFoundException]{Write-Warning -Message 'the path does not exist'}
catch [System.IO.IOException] {Write-Warning -Message 'The file cound not be written to the path, a duplicate filename may already exist'}
catch {Write-Warning -Message 'The file could not be created, unknown issue'}
