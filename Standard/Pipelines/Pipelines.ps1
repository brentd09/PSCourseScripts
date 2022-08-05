[CmdletBinding()]
Param (
  #[Parameter(Mandatory=$true)]
  [String]$FirstCommand = 'Get-Service',
  #[Parameter(Mandatory=$true)]
  [String]$SecondCommand = 'Stop-Process'
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
function Show-ByVal {
  Param (
    $FirstCmd,
    $SecondCmd,
    $FirstCmdType,
    $SecondCmdParamByVal
  )
  Clear-Host
  Write-Host -ForegroundColor Blue "ByValue Pipeline"
  Write-Host -ForegroundColor Blue "----------------"
  Write-Host "The first command " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmd  -NoNewline
  Write-Host " produces an object of type " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmdType
  Write-Host "The second command " -NoNewline
  Write-Host -ForegroundColor Red $SecondCmd -NoNewline
  Write-Host " accepts " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmdType -NoNewline
  Write-Host " objects " 
  Write-Host "being pipelined " -NoNewline
  Write-Host -ForegroundColor Blue "ByValue" -NoNewline
  Write-Host " via the parameter -" -NoNewline
  Write-Host -ForegroundColor Red $SecondCmdParamByVal[0].Name
  if ($SecondCmdParamByVal[0].Type -eq 'PSObject') {
    Write-Host "`nPSObject is a special case in which PSObject will accept any object" 
  }
  Write-Host 
  Write-Host -ForegroundColor Blue "FOR EXAMPLE"
  Write-Host -ForegroundColor Blue "-----------"
  Write-Host "$FirstCmd --> $FirstCmdType (Object)" -NoNewline
  Write-Host -ForegroundColor Green "  =====>> | =====>>  " -NoNewline
  Write-Host "-$($SecondCmdParamByVal[0].Name)[$($SecondCmdParamByVal[0].Type)] --> $SecondCmd"
  Write-Host
}

function Show-ByPropertyName {
  Param (
    $FirstCmd,
    $SecondCmd,
    $FirstCmdType,
    $FirstCmdProperties,
    $SecondCmdParamsByPN
  )
  Clear-Host
  Write-Host -ForegroundColor Blue "ByPropertName Pipeline"
  Write-Host -ForegroundColor Blue "----------------------"
  Write-Host "The first command " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmd  -NoNewline
  Write-Host " produces an object of type " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmdType
  Write-Host "However, the second command " -NoNewline
  Write-Host -ForegroundColor Red $SecondCmd -NoNewline
  Write-Host " does not allow " -NoNewline
  Write-Host -ForegroundColor Red $FirstCmdType -NoNewline
  Write-Host " objects "
  Write-Host "to be pipelined " -NoNewline
  Write-Host -ForegroundColor Blue "ByValue" -NoNewline
  Write-Host " via any of the parameters" 
  Write-Host
  Write-Host "Therefore the pipeline now tries to pipe " -NoNewline
  Write-Host -ForegroundColor Blue "ByPropertyName" -NoNewline
  Write-Host " in which property values "
  Write-Host "from the first command are pipelined into the parameters of the second command"
  Write-Host "if they are both spelt the same and both have the same data types"
  Write-Host 
  Write-Host -ForegroundColor Blue "FOR EXAMPLE"
  Write-Host -ForegroundColor Blue "-----------"

}

# MAIN CODE

# First lets see if ByValue will work, if not, lets see of ByPropertyName will work
$FirstCmdOutputType = Get-ObjectType -Command $FirstCommand
$SecondCmdParamByVal = Get-ObjectMember -Command $SecondCommand -PipelineMethod ByValue
if ($FirstCmdOutputType -in $SecondCmdParamByVal.Type) {
  $ByValMatchingParam = $SecondCmdParamByVal | Where-Object {$_.Type -eq $FirstCmdOutputType}
  Show-ByVal -FirstCmd $FirstCommand -SecondCmd $SecondCommand -FirstCmdType $FirstCmdOutputType -SecondCmdParam $ByValMatchingParam
}
elseif ($SecondCmdParamByVal.Type -eq 'PSObject') {
  $ByValMatchingParam = $SecondCmdParamByVal | Where-Object {$_.Type -eq 'PSObject'}
  Show-ByVal -FirstCmd $FirstCommand -SecondCmd $SecondCommand -FirstCmdType $FirstCmdOutputType -SecondCmdParam $ByValMatchingParam
}
else {
# If not, lets see of ByPropertyName will work
$FirstCmdOutputProperties = Get-ObjectProperty -Command $FirstCommand 
$SecondCmdParamByPN = Get-ObjectMember -Command $SecondCommand -PipelineMethod ByPropertyName
Show-ByPropertyName -FirstCmd $FirstCommand $SecondCommand -FirstCmdType $FirstCmdOutputType -FirstCmdProperties $FirstCmdOutputProperties -SecondCmdParamsByPN $SecondCmdParamByPN
}
