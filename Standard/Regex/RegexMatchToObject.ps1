function Get-SocketInfo {
  $RawNetStat = (netstat -anop tcp) | Select-String -Pattern "^\s+TCP.*$"
  foreach ($RawNS in $RawNetStat) {
    $RawNS -match "^\s+(?<Proto>TCP)\s+(?<SrcIP>\d+\.\d+\.\d+\.\d+)\:(?<SrcPort>\d+)\s+(?<DstIP>\d+\.\d+\.\d+\.\d+)\:(?<DstPort>\d+)\s+(?<State>\w+)\s+(?<PID>\d+)" *> $null
    #$Matches # Shows hash table of all the matches from previous -match command
    new-object -TypeName psobject -Property $Matches  | Select-Object -Property Proto,SrcIP,SrcPort,DstIP,DstPort,State,PID 
  }
}

Get-SocketInfo

