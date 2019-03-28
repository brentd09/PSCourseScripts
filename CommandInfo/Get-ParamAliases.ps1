[CmdletBinding()]
Param (
  [parameter(Mandatory=$true)]
  [string]$PSCmd 
)
try {
  (Get-Command $PSCmd -ErrorAction stop).Parameters.Values | Select-Object -Property Name,Aliases
}
catch {Write-Warning "There was an error locating the command $PSCmd"}