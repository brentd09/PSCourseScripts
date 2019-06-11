<#
.SYNOPSIS
  Shows how a pipelin will work
.DESCRIPTION
  FirstCommand | SecondCommand
  This script shows how a pipeline will work for two commands. It will 
  test the logic of ByValue pipeing first to see if this is possible. 
  If not it then will check ByPropertyName piping. If this fails it will 
  show that the pipeline is not possible.
.EXAMPLE
  Get-PipeLineMethod -FirstCommand 'get-service' -SecondCommand 'Stop-Service'
  FirstCommand | SecondCommand
  This script tries to simulate what would take place through the pipeline
  it will try to discover if the pipeline works and if it does, what method 
  of pipeline is used (ByValue or ByPropertyName)
.PARAMETER FirstCommand
  FirstCommand | SecondCommand
  ------------
  This is the first command in the pipeline from left to right
.PARAMETER SecondCommand
  FirstCommand | SecondCommand
                 -------------
  This is the second command in the pipeline
.NOTES
  General notes
  Created by: Brent Denny
  Created on:  8-May-2019
  Modified  : 11-Jun-2019
#>
[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [string]$FirstCommand,
  [Parameter(Mandatory=$true)]
  [string]$SecondCommand
)

Clear-Host
$FirstCommand  = (Get-Culture).TextInfo.ToTitleCase($FirstCommand)
$SecondCommand = (Get-Culture).TextInfo.ToTitleCase($SecondCommand)
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
  Write-Host -ForegroundColor Cyan "How Does the Pipe Line work`n---------------------------`n"
  If ($ByVal -eq $true -and $ByPN -eq $false) {
    Write-Host -NoNewline "   Pipeline:  "
    Write-host -ForegroundColor Green "$FirstCommand `| $SecondCommand `n"
    Write-Host -NoNewline "Pipe Method:  "
    Write-Host -ForegroundColor Green "ByValue"
    Write-Host -NoNewline "Object type:  "
    Write-Host -ForegroundColor Green $FirstCmdObjectType
    Write-host -NoNewline "  Parameter:  "
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
            "$FirstCommand Property"   = $Param.Name
            ObjectType         = $ParamTypeName
            "$SecondCommand Parameter"  = $Param.Name
          }
          $ByPNOutputObj = New-Object -TypeName psobject -Property $OutputHash
          $ByPNArray += $ByPNOutputObj
        }
      }
    }
    If ($ByPN -eq $true -and $ByVal -eq $false) {
      Write-Host -NoNewline "   Pipeline:  "
      Write-host -ForegroundColor Green "$FirstCommand `| $SecondCommand `n"
      Write-Host -NoNewline "Pipe method:  "
      Write-Host -ForegroundColor green "ByPropertyName"
      Write-Host -ForegroundColor Green -NoNewline "`nFollowing table shows the ByPropertyName Mappings:"
      $ByPNArray
    }
    if ($ByVal -eq $false -and $ByPN -eq $false) {
      Write-Host -ForegroundColor Red "The pipeline has no way of passing the data `n"
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