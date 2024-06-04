function New-SplattingTable {
  <#
  .SYNOPSIS
    This command builds a hashtable for splatting
  .DESCRIPTION
    This command gets the non common parameters from a command and arranges them in a 
    has table ready for splatting. it then coppies the hash table into the clipboard
    so that it can be pasted into your script. 
  .PARAMETER CommandName
    This parameter accepts a PowerShell command name, it will also check to see if it 
    recognises that command before proceeding  
  .PARAMETER ShowSplat
    Instead of copying the splatting table to the clipboard this will display the 
    hash table as output  
  .NOTES
    Created By: Brent Denny

    Change Log
    ----------
    Who                  When          What
    -------------------  -----------   ------------------------------------------
    Brent Denny          05-Jun-2024   Just completed the module

  .EXAMPLE
    New-SplattingTable -CommandName 'Get-Service'
    This example will find the non common parameters for the command Get-Service and 
    arrange them in a hash table that will be then copied into the ClipBoard ready 
    for pasting into your PowerShell script
  .EXAMPLE
    New-SplattingTable -CommandName 'Get-Service' -ShowSplat
    This example will find the non common parameters for the command Get-Service and 
    arrange them in a hash table that will be displayed as output from this command
  #>
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$CommandName,
    [switch]$ShowSplat
  )
  # Get the command
  try {$command = Get-Command -Name $CommandName -ErrorAction stop}
  catch {Write-Warning "$CommandName is not a valid command";break}
  
  # Create the start of the hash table
  $SplattingTable = "@{`n"
  
  # Populate the hash table with parameters
  $command.Parameters.Keys | ForEach-Object {
    # Exclude common parameters
    if ($command.Parameters[$_].ParameterType.Name -ne "SwitchParameter" -and $_ -notin [System.Management.Automation.Cmdlet]::CommonParameters) {
      $SplattingTable = $SplattingTable + "  $_" + " = ''`n"
    }
  }
  # Finish the hash table
  $SplattingTable = $SplattingTable + '}'
  # Decide to show or clipboard the splatting result
  if ($ShowSplat -eq $true) {return $SplattingTable}
  else {$SplattingTable | Set-Clipboard}
}