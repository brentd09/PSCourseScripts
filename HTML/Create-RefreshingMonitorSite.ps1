# $trig = New-JobTrigger -RepetitionInterval 0:01:00 -RepeatIndefinitely -at 09:13 -once
# Register-ScheduledJob -Name report -Trigger $trig -FilePath c:\Create-RefreshingMonitorSite.ps1
$Opac = .8
$CSS = @"
<style>
  h1 {font-size:400%;text-align:center;}
  body {background-image: url("ddls_contactus.jpg");background-size:cover;}
  table, th, td, tr {border:solid;border-collapse:collapse;width:100%;border-color:black;table-layout:fixed;font-size:110%}
  th {background-color:rgba(142, 142, 142,$Opac);Color:White;font-size:200%}
  .StoppedManual td {background-color:rgba(255, 144, 0,$Opac);}
  .StoppedAutomatic td {background-color:rgba(255, 0, 0,$Opac);}
  .StoppedDisabled td {background-color:rgba(255, 255, 0,$Opac);}
  .RunningManual td {background-color:rgba(2, 98, 252,$Opac);}
  .RunningAutomatic td {background-color:rgba(1, 181, 7,$Opac);}
</style>
"@

$HTMLDoc= Get-Service | 
  Select-Object Status,Name,StartType |
  Sort-Object -Property Status,StartType,Name |
  ConvertTo-Html -Head "<meta http-equiv='refresh' content='10'>$CSS" -PreContent "<h1>Service Monitoring</h1>" 
$OutDoc = $HTMLDoc -replace "<tr><td>(\w+)</td><td>(\w+)</td><td>(\w+)</td></tr>",'<tr class="$1$3"><td>$1</td><td>$2</td><td>$3</td></tr>' 

$OutDoc | Out-File C:\inetpub\wwwroot\index.html