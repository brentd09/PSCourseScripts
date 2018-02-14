$template = @"

Active Connections 

Proto  SrcIP SrcPort DstIP DstPort State PID
{Proto*:TCP} {SrcIP:192.168.0.40}:{SrcPort:54321} {DstIP:223.0.1.2}:{DstPort:443} {State:ESTABLISHED} {PID:9}
{Proto*:TCP} {SrcIP:10.168.0.40}:{SrcPort:41000} {DstIP:123.0.10.209}:{DstPort:3389} {State:LISTENING} {PID:100}
{Proto*:TCP} {SrcIP:172.168.0.40}:{SrcPort:0} {DstIP:11.0.1.2}:{DstPort:21} {State:ESTABLISHED} {PID:2300}
"@

(netstat -anop tcp).trim() | 
 ConvertFrom-String -TemplateContent $template | 
 Select-Object -Property *,@{n='IntPID';e={$_.pid -as [int]}} -ExcludeProperty pid |
 Sort-Object state,IntPID | 
 ft