$ExplorerProcessInfo = Get-Process -Name Explorer 
$CutDownObj = $ExplorerProcessInfo | Select-Object -Property Name,Id,CPU,VirtualMemorySize,WorkingSet,StartTime
$RawData = ($CutDownObj | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1) -split ','
Clear-Host
Write-Host -ForegroundColor Yellow  "RAW DATA`n`n"
$RawData.trim('"')
Write-Host -ForegroundColor DarkGray -NoNewline "`nHit ENTER to continue "
$dud = Read-Host
Write-Host -NoNewline -ForegroundColor Yellow  "`n`nRICH DATA FROM OBJECT (of type "
Write-Host -NoNewline -ForegroundColor Green "$($ExplorerProcessInfo.GetType().Name)"
Write-Host -ForegroundColor Yellow ")"
$CutDownObj