<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>
[CmdletBinding()]
Param ()
try {
  $SessionToCreateShare = New-PSSession -ComputerName LON-DC1 
  Invoke-Command -SessionName $SessionToCreateShare -ScriptBlock {New-SmbShare -Name 'WebDemo' -Path c:  
}
catch {}