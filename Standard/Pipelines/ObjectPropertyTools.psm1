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
    $Types = $Objects | Get-Member -MemberTyp Properties
    $Types | Where-Object {$_.Name -notin @('PSChildName','PSDrive','PSIsContainer','PSParentPath','PSPath','PSProvider')} 
    
  }

<#
#This will replace the alias properties with the actual types and show the types for all other properties
$PropTree = get-service |Show-PropertyTree 
$PropTree | Select-Object -Property Name,@{n='test';e={
  if ($_.membertype -ne 'AliasProperty') {($_.definition -split '\s+')[0]}
  else{
    $AliasName = ($_.definition -split '\s+')[-1]
    $AliasDefinition = $PropTree | Where-Object {$_.Name -eq $AliasName} 
    ($AliasDefinition.Definition -split '\s+')[0]
  }}
}
#>


}
