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
$FirstObjectType = (Invoke-Expression $FirstCommand)[0].gettype().name
$SecondCmdParamThatPipe = (get-help -full $SecondCommand).parameters.parameter | 
  Select-Object -Property Name,PipelineInput,type | 
  Where-Object {$_.pipelineinput -like '*byValue*'}
foreach ($TypeName in $SecondCmdParamThatPipe) {
  $pipeingParam = $TypeName.Name
  if ($TypeName.type.name -match $FirstObjectType) {$ByVal = $true; break}
}
# Try ByValue logic first
If ($ByVal -eq $true) {
  Write-host -ForegroundColor Yellow -NoNewline "$FirstCommand `| $SecondCommand "
  Write-Host -NoNewline "will pipeline data "
  Write-Host -ForegroundColor green "ByValue"
  Write-Host -NoNewline "The first command created an object type of "
  Write-Host -ForegroundColor green $FirstObjectType
  Write-host -NoNewline "The second command can accept "
  write-host -NoNewline -ForegroundColor Green $FirstObjectType
  Write-Host -NoNewline " ByValue with parameter "
  Write-Host -ForegroundColor Green $PipeingParam
}
else {
  
}

# Test pipeline by PropertyName if Value failed