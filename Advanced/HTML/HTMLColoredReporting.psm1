function New-ProcessReport {
  <#
    .SYNOPSIS
      This creates a website report on services
    .DESCRIPTION
      The website created by the command is color coded with CSS in the <tr> tags if the 
      VirtualMemorySize is over various thresholds given as parameters to the command, 
      the critical values go red and the warning values are yellow 
    .EXAMPLE
      New-ProcessReport -CriticalMemUsage 300000000 -WarningMemUsage 100000000 -FilePath c:\inetpub\wwwroot\reports -FileName index.html
      This will 
    .NOTES
      General notes
      Created by: Brent Denny
      Created on: 16 Mar 2018
  #>
  [CmdletBinding()]
  Param(
    [int]$CriticalMemUsage = 300000000,
    [int]$WarningMemUsage = 100000000,
    [string]$FilePath = "c:\inetpub\wwwroot\",
    [string]$FileName = "index.html"
  )
  $FullReportPath = ($FilePath + '\' + $FileName) -replace "\\{2,}",'\'
  if (-not (Test-Path -Path $FilePath -PathType Container )) {new-item -Path $FilePath -ItemType Directory -Force}
  # Cascading Style Sheet for the webpage report table
  $CSS = @'
  <style>
    table {text-align: right; border: 3px solid black; border-collapse: collapse; width: 90%}
    td {border: 3px solid black; padding: 8px;}
    th {text-align: center;background-color: Blue; color: floralwhite; border: 3px solid black ; padding: 8px;}
  </style>
'@

  $SvcHost = Get-Process | Select-Object -Property Id,Name,CPU,VirtualMemorySize
  $RawFragment = $SvcHost |  ConvertTo-Html -Fragment 
  $WarnObjs = @()
  $SvcHostLastIndex = ($SvcHost.Count)-1
  # find offending objects figure out if critial or warning and create obj array with index and color of offending object
  foreach ($Index in (0..$SvcHostLastIndex)) {
    if ($SvcHost[$Index].VirtualMemorySize -gt $CriticalMemUsage  ) {$WarningProps = @{Flag = $Index + 3; WarningColor = 'Red'}}
    elseif ($SvcHost[$Index].VirtualMemorySize -gt $WarningMemUsage  ) {$WarningProps = @{Flag = $Index + 3; WarningColor = 'Orange'}}    
    #else {$WarningProps = @{Flag = $Index + 3; WarningColor = 'Green'}} # This paint all non offending rows as green, I did not like this
    $WarnObjs += New-Object -TypeName psobject -Property $WarningProps     
  }
  # step through each offending issue and recode the html with the CSS style embedded in the <tr> tag
  foreach ($WarnObj in $WarnObjs) {
    $RawFragment[$WarnObj.Flag] = $RawFragment[$WarnObj.Flag] -replace "<tr>","<tr style=`"background-color:$($WarnObj.WarningColor)`">"
  }
  # Convert the HTML fragment into a full HTML doc and save
  ConvertTo-Html -Body $RawFragment -Head $CSS | Out-File $FullReportPath
}