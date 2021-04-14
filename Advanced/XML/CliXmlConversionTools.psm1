function ConvertTo-Clixml {
  <#
  .SYNOPSIS
    This converts PowerShell objects into CLIXML for standard output
  .DESCRIPTION
    This does the same thing the Export-Clixml command does, however it 
    does not write the result to a file, but instead sends the xml content
    to standard output as a string type 
  .EXAMPLE
    Get-Service -Name BITS,Spooler | ConvertTo-Clixml
    This will get the bits and spooler service objects and convert them to
    Climl format.
  .INPUTS
    PSobject
  .OUTPUTS
    String
  .NOTES
    General notes
      Recreated from a script on PowerShell Gallery
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    [PSObject]$InputObject
  )

  begin {$ErrorActionPreference = 'Stop'}
  process {
    foreach ($Obj in $InputObject) {
      try {
        [System.Management.Automation.PSSerializer]::Serialize($Obj)
      } 
      catch {
        Write-Warning 'Failed to convert the objects into CLI-XML'
      }
    }
  }
  end {}
}


function ConvertFrom-Clixml {
    <#
  .SYNOPSIS
    This converts CLIXML from standard input to PowerShell objects
  .DESCRIPTION
    This does the same thing the Import-Clixml command does, however it 
    does not read the contents of a file, but instead reads the input 
    from standard input as a string type 
  .EXAMPLE
    $ClixmlData | ConvertTo-Clixml
    This will convert the clixml content back to PowerShell objects
  .NOTES
    General notes
      Recreated from a script on PowerShell Gallery
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    [String[]]$CLIXMLStrings
  )
  
  begin {
    $ErrorActionPreference = 'Stop'
    Set-Variable -Name 'RegEx' -Value '(?<!^)(?=<Objs)' -Option 'Constant'
  }
      
  process {
    foreach ($CLIXMLString in $CLIXMLStrings) {
      try {
        foreach ($CLIXMLSection in ($CLIXMLString -split $RegEx)) {
          [System.Management.Automation.PSSerializer]::Deserialize($CLIXMLSection)
        }
      }
      catch  {  Write-Warning 'Data could not be deserialised from CLI-XML' }
    }
  }
}
