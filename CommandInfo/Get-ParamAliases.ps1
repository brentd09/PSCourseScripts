<#
.SYNOPSIS
  This script finds any parameter that has aliases and lists them
.DESCRIPTION
  This script uses information produced from the Get-Command command
  to determine if the parameters for a command have aliases, and if
  so it will show them 
.EXAMPLE
  Get-ParamAlias -PSCmd 'Get-Sevice'
  This will find all of the parameters for the Get-Service cmdlet and
  will determine if any have aliases and display them
.NOTES
  General notes
    Created by Brent Denny
    Created on 08 Apr 2019
#>
[CmdletBinding()]
Param (
  [parameter(Mandatory=$true)]
  [string]$PSCmd 
)
try {
  $GCMResult = Get-Command $PSCmd -ErrorAction stop
  if ($GCMResult.CommandType -in @('Cmdlet','Function')) {
    $GCMResult.Parameters.Values |
      Where-Object {$_.Aliases.Count -ge 1} | 
      Select-Object -Property @{n='ParameterName';e={$_.Name}},Aliases
  }
  else {Write-Warning "$PSCmd is not a PowerShell Cmdlet"}
}
catch {Write-Warning "There was an error locating the Cmdlet $PSCmd"}