[cmdletbinding()]
Param ()

Clear-Host
try { throw 'Terminating Error' }
catch [System.IO.IOException]{Write-host -ForegroundColor Yellow 'The error must have been an IO error'}
Write-Host 'Executing Clean Up Code'
