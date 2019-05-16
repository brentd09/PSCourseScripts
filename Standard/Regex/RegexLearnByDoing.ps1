$MatchName = @(); $NoMatchName = @()
Clear-Host
Write-Host -ForegroundColor Green  "Learn RegEx by practice"
Write-Host -ForegroundColor Green "-----------------------"
Write-Host -ForegroundColor Cyan  "No Character patterns"
Write-Host -ForegroundColor Yellow -NoNewline '  ^ '
Write-Host -NoNewline '(Start of String)               '
Write-Host -ForegroundColor Yellow -NoNewline '$ '
Write-Host '(End of string)                      '
Write-Host -ForegroundColor Cyan  "`nCharacter"
Write-Host -ForegroundColor Yellow -NoNewline '  . '
Write-Host -NoNewline '(any char)                     '
Write-Host -ForegroundColor Yellow -NoNewline '\s '
Write-Host -NoNewline '(space or tab)                      '
Write-Host -ForegroundColor Yellow -NoNewline '\S '
Write-Host '(not a space or tab)'
Write-Host -NoNewline '                                   '
Write-Host -ForegroundColor Yellow -NoNewline '\w '
Write-Host -NoNewline '(Alpha-numeric)                     '
Write-Host -ForegroundColor Yellow -NoNewline '\W '
Write-Host '(not alpha-numeric)'
Write-Host -ForegroundColor Yellow -NoNewline '                                   \d '
Write-Host -NoNewline '(digit 0-9)                    '
Write-Host -ForegroundColor Yellow -NoNewline '     \D '
Write-Host '(non digit)'
Write-Host -ForegroundColor Cyan  "Quantifiers"
Write-Host -ForegroundColor Yellow -NoNewline '  ?'
Write-Host -NoNewline ' (0 or 1 prev char)              '
Write-Host -ForegroundColor Yellow -NoNewline '* '
Write-Host -NoNewline '(0 or more of prev char)             '
Write-Host -ForegroundColor Yellow -NoNewline '+ '
Write-Host '(1 or more of prev char)'
Write-Host -ForegroundColor Yellow -NoNewline '{2} '
Write-Host -NoNewline '(2 of Prev char)            '
Write-Host -ForegroundColor Yellow -NoNewline '{1,3} '
Write-Host -NoNewline '(prev char 1 or 2 or 3 times)     '
Write-Host -ForegroundColor Yellow -NoNewline '{2,} '
Write-Host '(2 or more times the previous char)'
Write-Host -ForegroundColor Cyan  "`nGroups and Ranges"
Write-Host -ForegroundColor Yellow -NoNewline '[a-g] '
Write-Host -NoNewline ' (a char from a to g)      '
Write-Host -ForegroundColor Yellow -NoNewline '[ab] '
Write-Host -NoNewline '(a char matching a or b)         '
Write-Host -ForegroundColor Yellow -NoNewline '(\w+) '
Write-Host '(Capture one or more word characters)'
Write-Host -ForegroundColor Yellow -NoNewline '[^a-g] '
Write-Host -NoNewline '(not char from a to g)   '
Write-Host -ForegroundColor Yellow -NoNewline '[^ab] '
Write-Host -NoNewline '(not a or b)                     '
Write-Host -ForegroundColor Yellow -NoNewline '(bob|john) '
Write-Host  '(bob or john)'
$MatchName  = @('Server-SYD-01','Server-QLD-03')
$NoMatchName = @('Server-MEL-01','Server-SYD-10')
Write-Host -ForegroundColor Red "`n------------------------------------------------------------------------------------------------------------------`n"
Write-Host -ForegroundColor Green   "What Regex string would match the following"
Write-Host -ForegroundColor Green   "-------------------------------------------"
Write-Host -ForegroundColor Yellow   "Match all of these"
$MatchName
Write-Host -ForegroundColor Yellow -NoNewline  "`nBut "
Write-Host -ForegroundColor Red -NoNewline "not "
Write-Host -ForegroundColor Yellow "match any of these"
$NoMatchName
$regex = Read-Host -Prompt "`nEnter the RegEx string"
$TotalMatches = ($MatchName).count
$CountMatches = ($MatchName -match $regex ).count
$CountNoMatch = ($NoMatchName -match $regex).count
if ($CountMatches -eq $TotalMatches -and $CountNoMatch -eq 0) { 
  Write-Host -ForegroundColor Green "`nRegex was successful"
  Write-Host -NoNewline -ForegroundColor Green "`nThe Regex string: "
  Write-Host -NoNewline $regex 
  Write-Host -ForegroundColor Green " matched the following"
  $MatchName -match $regex
  $NoMatchName -match $regex
}
else { 
  Write-Host -ForegroundColor Red "`nThe regex failed"
  Write-Host -NoNewline -ForegroundColor Red "`nThe Regex string: "
  Write-Host -NoNewline $regex 
  Write-Host -ForegroundColor Red " matched the following"
  $MatchName -match $regex
  $NoMatchName -match $regex
  Write-Host -ForegroundColor Cyan "`nSome Examples of possible Regex would be"
  Write-Host -ForegroundColor Green "Server-(SYD|QLD)-0\d`n.*-(SYD|QLD)-0\d`n.{6}-(SYD|QLD)-0\d"
}

