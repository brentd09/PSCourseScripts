[CmdletBinding()]
Param (
  [Parameter(Mandatory=$true)]
  [string]$FirstCommand,
  [Parameter(Mandatory=$true)]
  [string]$SecondCommand
)

# Test pipeline by Value first
$ByVal = $false
$ByPN  = $false
$FirstCmdObjectType = (Invoke-Expression $FirstCommand)[0].gettype().name
$GetMemberResult = (Invoke-Expression $FirstCommand)[0] | Get-Member -MemberType Properties
$FirstCmdProperties = $GetMemberResult | Select-Object Name, @{n='PropertyObjType';e={
  #  This tests to see if the member is an alias if not get the type, if it is then find the property it is refering to first
  if ($_.MemberType -notlike 'Alias*') {$_.definition -replace '^(?:\w+\.)*(\w+)\W.*$','$1'}
  else {($GetMemberResult | Where-Object name -eq ($_.definition -replace '^.+=\W*(\w+)$','$1')) -replace '^(?:\w+\.)*(\w+)\W.*$','$1'}
}}
$SecondCmdParamThatPipeByVal = (get-help -full $SecondCommand).parameters.parameter | 
  Select-Object -Property Name,PipelineInput,type | 
  Where-Object {$_.pipelineinput -like '*byValue*'}
$SecondCmdParamThatPipeByPN = (get-help -full $SecondCommand).parameters.parameter | 
  Select-Object -Property Name,PipelineInput,type | 
  Where-Object {$_.pipelineinput -like '*byPropertyName*'}  
foreach ($TypeName in $SecondCmdParamThatPipeByVal) {
  $PipeingByValParam = $TypeName.Name
  if ($TypeName.type.name -match $FirstCmdObjectType) {$ByVal = $true; break}
}
# Try ByValue logic first
If ($ByVal -eq $true) {
  Write-host -ForegroundColor Yellow -NoNewline "$FirstCommand `| $SecondCommand "
  Write-Host -NoNewline "will pipeline data "
  Write-Host -ForegroundColor green "ByValue"
  Write-Host -NoNewline "The first command created an object of type "
  Write-Host -ForegroundColor green $FirstCmdObjectType
  Write-host -NoNewline "The second command can accept "
  write-host -NoNewline -ForegroundColor Green $FirstCmdObjectType
  Write-Host -NoNewline " ByValue via the parameter "
  Write-Host -ForegroundColor Green $PipeingByValParam
}
else {
  

}

# Test pipeline by PropertyName if Value failed