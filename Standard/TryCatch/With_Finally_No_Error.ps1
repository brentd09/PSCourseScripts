[cmdletbinding()]
Param ()

Clear-Host
try { Write-Host 'No error produced fron this command' }
catch [System.IO.IOException]{Write-host -ForegroundColor Yellow 'The error must have been an IO error'}
finally {Write-Host 'Executing Clean Up Code'}
