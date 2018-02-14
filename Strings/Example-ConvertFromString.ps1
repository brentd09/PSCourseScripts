(netstat -anop tcp).trim() | Select-Object -skip 2  | 
 ConvertFrom-String -PropertyNames "Proto","SrcIP","SrcPort","DstIP","DstPort","State","PID" -Delimiter '\s+|\:' 