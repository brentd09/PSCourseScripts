function Get-PipelineMethod {
  <#
  .SYNOPSIS
    Given two commands in a pipeline this command discovers if and how the pipeline will operate
  .DESCRIPTION
    PowerShell always tries to pipeline data between two commands using ByValue first, if 
    this is not possbile then PowerShell tries ByPropertyName next. 
    Given two commands in a pipeline this command will determine whether the pipeline will
    work and how it will pipe the information. It will determine whether the pipeline will
    use ByValue or ByPropertyName piping methods. 
    For ByValue pipelines it will show the first and second commands along with the object 
    type that is being sent across the pipeline from the output of the first command, and 
    which parameter in the second command will accept that object type ByValue.
    For ByPropertyName the first and second commands will be listed along with each property
    from the object produced by the first command that coresponds to parameters in the second 
    command, the condition that allows matches between properties to parameters is that they 
    must be spelt the same and have the same object type.
    This program uses standard pipeline proof techniques such as:
    FirstCommand | Get-Member
    Get-Help -Full SecondCommmand
    It then compares the results to determine how/if the pipeline can pipe the data from the 
    FirstCommand to the SecondCommand
  .PARAMETER FirstCommand
    This represents the first command in a pipeline
  .PARAMETER SecondCommand
    This represents the second command in a pipeline
  .NOTES
    Created
      By: Brent Denny 
      On: 2 Aug 2022
    Last Edited:
      By: Brent Denny 
      On: 8 Aug 2022

    Version History
    Version         Changes made
    0.9             Final edits to get the ByPropertyName result working, there is still an issue with the ByValue output if the 
                    first command outputs multiple objects, I have not resolved this problem yet
    0.95            Fixed a problem that was declaring a real command as one that did not exist         
    0.98            Fixed the Help content       
  .EXAMPLE
    Get-PipelineMethod -FirstCommand Get-Service -SecondCommand Stop-Service
    If you are trying to determine how: 
    Get-Service -Name Test | Stop-Service 
    will pipeline the information. This command will determine how this will 
    work and what information is pipelined from the first command to the 
    second command
  #>
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [String]$FirstCommand ,
    [Parameter(Mandatory=$true)]
    [String]$SecondCommand
  )
  function Get-ObjectType {
    Param (
      [string]$Command 
    )
    try {
      $CmdObjTypes = ((Invoke-Expression $Command -ErrorAction stop) | ForEach-Object {$_.gettype()}).Name | Select-Object -Unique
      return $CmdObjTypes
    }
    catch {
      Write-Warning "$FirstCommand - does not appear to be a valid command"
      break
    }  
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
    $CmdHelp = try {
      $AllCommands = (Get-Command).Name 
      if ($AllCommands -notcontains $Command) {throw "No such command"}
      Get-help -Full -Name $Command -ErrorAction stop
    }
    catch {
      Write-Warning "There does not seem to be a help topic the the command $SecondCommand`nThis command requires PowerShell help pages for the second command"
      break
    }
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
    Write-Host -ForegroundColor Cyan "ByValue Pipeline"
    Write-Host -ForegroundColor Cyan "----------------"
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
    Write-Host -ForegroundColor Cyan "ByValue" -NoNewline
    Write-Host " via the parameter -" -NoNewline
    Write-Host -ForegroundColor Red $SecondCmdParamByVal[0].Name
    if ($SecondCmdParamByVal[0].Type -eq 'PSObject') {
      Write-Host "`nPSObject is a special case in which PSObject will accept any object" 
    }
    Write-Host 
    Write-Host -ForegroundColor Cyan "FOR EXAMPLE"
    Write-Host -ForegroundColor Cyan "-----------"
    Write-Host "$FirstCmd --> (Object)[$FirstCmdType] " -NoNewline
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
    Write-Host -ForegroundColor Cyan "ByPropertName Pipeline"
    Write-Host -ForegroundColor Cyan "----------------------"
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
    Write-Host -ForegroundColor Cyan "ByValue" -NoNewline
    Write-Host " via any of the parameters" 
    Write-Host
    Write-Host "Therefore the pipeline now tries to pipe " -NoNewline
    Write-Host -ForegroundColor Cyan "ByPropertyName" -NoNewline
    Write-Host " in which property values "
    Write-Host "from the first command are pipelined into the parameters of the second command"
    Write-Host "on the condition that they are both spelt the same and both have the same data types"
    Write-Host 
    Write-Host -ForegroundColor Cyan "FOR EXAMPLE"
    Write-Host -ForegroundColor Cyan "-----------"
    '{0,-50}{1,13}{2,23}{3,-50}' -f "First Command","","","Second Command"
    '{0,-50}{1,13}{2,23}{3,-50}' -f "-------------","","","--------------"
    '{0,-50}{1,13}{2,23}{3,-50}' -f $FirstCmd,"","",$SecondCmd
    Write-Host
    '{0,-50}{1,13}{2,23}{3,-50}' -f "Properties","","","Matching Parameters"
    '{0,-50}{1,13}{2,23}{3,-50}' -f "----------","","","-------------------"
    $MatchingPropsToParams = @() 
    foreach ($FirstCmdProp in $FirstCmdProperties) {
      if ($FirstCmdProp.Name -in $SecondCmdParamByPN.Name) {
        $MatchingParam  = $SecondCmdParamsByPN | Where-Object {$_.Name -eq $FirstCmdProp.Name}
        if ($FirstCmdProp.Type -eq $MatchingParam.Type) {
          $MatchingPropsToParams += "$($FirstCmdProp.Name)[$($FirstCmdProp.Type)],=====>|=====>,             ,$($MatchingParam.Name)[$($MatchingParam.Type)]"
        }
      }
    }
    If ($MatchingPropsToParams.Count -gt 0) {
      foreach ($MatchingPropToParam in $MatchingPropsToParams) {
        '{0,-50}{1,13}{2,23}{3,-50}' -f $MatchingPropToParam.split(',')
      }
    }
    else {
      Write-Host "There are no matches, so that means that pipelining ByValue or ByPropertName is not possible"
    }
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
  $ShowPNSplat = @{
    FirstCmd            = $FirstCommand 
    SecondCmd           = $SecondCommand
    FirstCmdType        = $FirstCmdOutputType 
    FirstCmdProperties  = $FirstCmdOutputProperties 
    SecondCmdParamsByPN = $SecondCmdParamByPN
  }
  Show-ByPropertyName @ShowPNSplat
  }
}
