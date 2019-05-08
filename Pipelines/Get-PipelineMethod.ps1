<#
.SYNOPSIS
  Shows how a pipelin will work
.DESCRIPTION
  This script shows how a pipeline will work for two commands. If that 
  fails it will test the logic of ByValue first to see if this is possible. 
  If notiIt then will check ByPropertyName piping. If this fails it will 
  show that the pipeline is not possible.
.EXAMPLE
  Get-PipeLineMethod -FirstCommand 'get-service' -SecondCommand 'Stop-Service'
  This will discover if the pipeline works and if it does, what method 
  of pipeline is used (ByValue or ByPropertyName)
.PARAMETER FirstCommand
  This is the first command in the pipeline from left to right
.PARAMETER SecondCommand
  This is the second command in the pipeline
.NOTES
  General notes
  Created by: Brent Denny
  Created on: 8-May-2019
#>
[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [string]$FirstCommand,
  [Parameter(Mandatory=$true)]
  [string]$SecondCommand
)

Clear-Host
$ByPNArray = @()
$ByVal = $false
$ByPN  = $false
$SimpleString = $false
try {
  try {
    Get-Command $FirstCommand -ErrorAction stop *> $null
  }
  catch {
    $FirstCmdObjectType = (Invoke-Expression $FirstCommand).GetType().Name
    $GetMemberResult = Invoke-Expression $FirstCommand | Get-Member -MemberType Properties
    $SimpleString = $true
  }
  finally {
    if ($SimpleString -eq $false) {
        $FirstCmdObjectType = (Invoke-Expression $FirstCommand -ErrorAction stop)[0].gettype().name
        $GetMemberResult = (Invoke-Expression $FirstCommand -ErrorAction stop)[0] | Get-Member -MemberType Properties
    }
  }
  $FirstCmdProperties = $GetMemberResult | Select-Object Name, @{n='PropertyObjType';e={
  #  This tests to see if the member is an alias if not get the type, if it is then find the property it is refering to first
  if ($_.MemberType -notlike 'Alias*') {$_.definition -replace '^(?:\w+\.)*(\w+)\W.*$','$1'}
  else {($GetMemberResult | Where-Object name -eq ($_.definition -replace '^.+=\W*(\w+)$','$1')) -replace '^(?:\w+\.)*(\w+)\W.*$','$1'}
  }}
  $SecondCmdParamThatPipeByVal = (get-help -full $SecondCommand -ErrorAction stop).parameters.parameter | 
    Select-Object -Property Name,PipelineInput,type | 
    Where-Object {$_.pipelineinput -like '*byValue*'}
  $SecondCmdParamThatPipeByPN = (get-help -full $SecondCommand -ErrorAction stop).parameters.parameter | 
    Select-Object -Property Name,PipelineInput,type | 
    Where-Object {$_.pipelineinput -like '*byPropertyName*'}  
  foreach ($TypeName in $SecondCmdParamThatPipeByVal) {
    $PipeingByValParam = $TypeName.Name
    if ($TypeName.type.name -match $FirstCmdObjectType) {$ByVal = $true; break}
  }
  # Try ByValue logic first
  Write-Host -ForegroundColor Yellow "How Does the Pipe Line work`n---------------------------`n"
  If ($ByVal -eq $true -and $ByPN -eq $false) {
    Write-host -ForegroundColor Yellow -NoNewline "$FirstCommand `| $SecondCommand "
    Write-Host -NoNewline "will pipeline data "
    Write-Host -ForegroundColor green "ByValue"
    Write-Host -NoNewline "The FIRST COMMAND created an object of type "
    Write-Host -ForegroundColor green $FirstCmdObjectType
    Write-host -NoNewline "The SECOND COMMAND can accept "
    write-host -NoNewline -ForegroundColor Green $FirstCmdObjectType
    Write-Host  " piped "
    Write-Host -NoNewline "ByValue via the parameter "
    Write-Host -ForegroundColor Green $PipeingByValParam
  }
  else {
    foreach ($Param in $SecondCmdParamThatPipeByPN) {
      $ParamTypeName =  $Param.Type.Name -replace '([a-z]+)[^a-z]*','$1'
      if ($Param.Name -in $FirstCmdProperties.Name) {
        $FirstCmdPropEqToParam = $FirstCmdProperties | Where-Object {$_.name -eq $Param.Name}
        if ($FirstCmdPropEqToParam.PropertyObjType -eq $ParamTypeName) {
          $ByPN = $true
          $OutputHash = [ordered]@{
            FirstCommandProperty   = $Param.Name
            ObjectType             = $ParamTypeName
            SecondCommandParameter = $Param.Name
          }
          $ByPNOutputObj = New-Object -TypeName psobject -Property $OutputHash
          $ByPNArray += $ByPNOutputObj
        }
      }
    }
    If ($ByPN -eq $true -and $ByVal -eq $false) {
      Write-host -ForegroundColor Yellow -NoNewline "$FirstCommand `| $SecondCommand "
      Write-Host -NoNewline "will pipeline data "
      Write-Host -ForegroundColor green "ByPropertyName"
      Write-Host 'The following table shows properties from the FIRST COMMAND'
      Write-Host -NoNewline 'that will pipe '
      Write-Host -ForegroundColor Green -NoNewline 'BYPROPERTYNAME'
      Write-Host ' to the corresponding'
      Write-Host 'parameters in the SECOND COMMAND with the same names'
      $ByPNArray
    }
    if ($ByVal -eq $false -and $ByPN -eq $false) {
      Write-Host -ForegroundColor Red "The pipeline has no way of passing the data"
    }
  }
}
Catch [System.Management.Automation.CommandNotFoundException] {
  Write-Warning "The first command does not exist"
}
catch [Microsoft.PowerShell.Commands.HelpNotFoundException] {
  Write-Warning "The second command does not exist"
}
catch {
  Write-Warning "An error was detected with the script"
}