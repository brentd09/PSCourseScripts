[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [String]$FirstCommand,
  [Parameter(Mandatory=$true)]
  [String]$SecondCommand
)
function Get-ObjectType {
  Param (
    [string]$Command 
  )
  $CmdObjTypes = ((Invoke-Expression $Command ) | ForEach-Object {$_.gettype()}).Name | Select-Object -Unique
  return $CmdObjTypes
}
function Get-ObjectProperty {
  Param (
    [string]$Command 
  )
  $CmdProperties =  Invoke-Expression $Command | Get-Member -MemberType Properties
  $CmdPropTypes = $CmdProperties | Select-Object name,MemberType,@{
    n='Type';
    e={
      if ($_.MemberType -eq 'AliasProperty') {
        $AliasTo = ($_.Definition -split '\s+')[-1]
        $MappedType = ($CmdProperties | Where-Object {$_.Name -eq $AliasTo}).Definition
        (($MappedType -split '\s')[0]) -replace '^.*\.','' -replace '\[\]',''
      }
      else {(($_.Definition -split '\s')[0]) -replace '^.*\.','' -replace '\[\]',''}
    }
  }
  return $CmdPropTypes 
}
function Get-ObjectMember {
  Param (
    [string]$Command,
    [ValidateSet('ByValue','ByPropertyName')]
    [string]$PipelineMethod
  )
  $CmdHelp = Get-help -Full -Name $Command
  $PipelineParams = foreach ($Parameter in $CmdHelp.parameters.parameter) {
    if ($Parameter.PipelineInput -match $PipelineMethod) {
      $ByPNProps = [ordered]@{
        Name   = $Parameter.Name
        Type   = $Parameter.Type.Name -replace '^.*\.','' -replace '\[\]',''
        Method = $PipelineMethod
      }
      New-Object -TypeName psobject -Property $ByPNProps
    }
  }
  return $PipelineParams
}

#Get-ObjectType -Command $FirstCommand
Get-ObjectProperty -Command $FirstCommand 
Out-String 
Get-ObjectMember -Command $SecondCommand -PipelineMethod ByPropertyName
