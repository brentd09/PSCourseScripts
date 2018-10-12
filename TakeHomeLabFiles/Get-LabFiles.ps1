[cmdletbinding()]
Param(
  [Parameter(DontShow)]
  $LabCred = (Get-Credential -Message "ENTER THE LAB CREDENTIALS" -UserName "adatum\administrator"),
  [ValidatePattern('[a-z0-9]+')]
  [string]$DestinationFolder = 'CourseLabFiles1',
  [ValidatePattern('[c-z]\:(\\[a-z0-9]*)+')]
  [string]$SourcePath = 'e:\'
)
$VMList = Get-VM 
Clear-Host 
Write-Host -ForegroundColor Green "Choose which VM to copy files from"
$MenuCount = 0
foreach ($VM in $VMList) {
  $MenuCount++
  Write-Host "$MenuCount - " -ForegroundColor Green -NoNewline
  $VM.Name 
}
$Choice = Read-Host -Prompt "Choose a number from the menu"
if ($Choice -ge 1 -and $Choice -le $MenuCount) {
  $CopyFromVM = $VMList[($Choice-1)].Name
  New-Item -Path D:\ -Name $DestinationFolder -ItemType Directory -ErrorAction SilentlyContinue
  $Session  = New-PSSession -VMName $CopyFromVM -Credential $LabCred
  $CopyTo   = 'D:\' + $DestinationFolder
  $copyFrom = ($SourcePath + '\*') -replace '\\{2,}','\'
  Copy-Item -FromSession $Session -Path $copyFrom -Destination $CopyTo -Recurse -Force -ErrorAction SilentlyContinue
}