$trig = New-JobTrigger -RepetitionInterval 0:01:00 -RepeatIndefinitely -at 00:00 -once
Register-ScheduledJob -Name report -Trigger $trig -ScriptBlock {
$CSS = @'
<style>
  body {background-color:rgba(86, 86, 186,.4)}
  table, th, td, tr {border:solid;border-collapse:collapse;width:50%;border-color:black}
  th {background-color:LightGray;}
  .Stopped {background-color:rgba(193, 0, 0,1);color:white;}
  .Running {background-color:rgba(0, 135, 51,.3);}
</style>
'@

$HTMLDoc= Get-Service -Name Browser,LanmanServer,LanmanWorkstation,Audiosrv,BITS,Dhcp,Dnscache,Netlogon,Spooler,W32Time,wuauserv | 
  Select-Object Status,StartType,Name |
  ConvertTo-Html -Head "<meta http-equiv='refresh' content='10'>$CSS" -PreContent "<h1>Servicng Monitoring</h1>" 
$OutDoc = $HTMLDoc -replace "<tr><td>(\w+)</td>", '<tr class="$1"><td>$1</td>' 
$OutDoc | Out-File C:\inetpub\wwwroot\index.html
}