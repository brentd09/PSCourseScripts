function Show-PropertyTree {
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
  Param (
    [Parameter(ValueFromPipeline)]
    [psobject]$InputObject
  )
 
  Begin {
    $Objects= @()
  }
  Process {
    [array]$Objects += $InputObject
      }  
  End {
#    foreach ($Object in $Objects) {
      $InitialType = ($Objects | Get-Member).TypeName
      $Types = $Objects | Get-Member -MemberType Properties
      $Types | Where-Object {$_.Name -notin @('PSChildName','PSDrive','PSIsContainer','PSParentPath','PSPath','PSProvider')}  | 
        Select-Object -Property @{n='PropertyName';e={$_.Name}},@{n='Type';e={
          if ($_.membertype -ne 'AliasProperty') {(($_.definition -split '\s+')[0]).trimend('[]')}
          else{
            $AliasName = ($_.definition -split '\s+')[-1]
            $AliasDefinition = $Types | Where-Object {$_.Name -eq $AliasName} 
            (($AliasDefinition.Definition -split '\s+')[0]).TrimEnd('[]')
          }
        }
      }
#    }  
  }
}
