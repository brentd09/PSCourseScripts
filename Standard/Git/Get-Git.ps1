$gitpage = Invoke-WebRequest -Uri 'https://git-scm.com/download/win' -UseBasicParsing 
$latestlink = ($gitpage.links | Where-Object {$_ -match '64-bit Git for Windows Setup'}) -replace '^.+href="(https.+exe)".+$','$1'
$Gitexe = $latestlink -replace 'https.+\/','' 

$web = [System.Net.WebClient]::new()
$web.DownloadFile($latestlink,$Gitexe)

