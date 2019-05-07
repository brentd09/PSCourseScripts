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
$SecondCmdParamThatPipe = (get-help -full stop-service).parameters.parameter | 
  Select-Object -Property Name,PipelineInput,type | 
  Where-Object {$_.pipelineinput -like '*byValue*'}
foreach ($TypeName in $SecondCmdParamThatPipe.Type.Name) {
  if ($TypeName -match $FirstObjectType) {$ByVal = $true; break}
}
If ($ByVal -eq $true) {
  Write-host -ForegroundColor Yellow -NoNewline "$FirstCommand `| $SecondCommand "
  Write-Host -NoNewline "will pipeline data "
  Write-Host -ForegroundColor green "ByValue"
}




# Test pipeline by PropertyName if Value failed