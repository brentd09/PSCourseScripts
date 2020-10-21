# from https://www.youtube.com/watch?v=kvSbb6g0tMA where Drew Furgiuele hosts a fantastic video 
# regarding muti threading with runspaces
# This is almost an exact replica of the script he used in the video
$Computers = @('lon-dc1','lon-svr1')

$RunSpacePool = [runspacefactory]::CreateRunspacePool(1,4)
$RunSpacePool.ApartmentState = 'MTA'
$RunSpacePool.Open()

$CodeContainer = {
  Param (
    [string]$ComputerName
  )
  $Processes = Invoke-Command -ComputerName -ScriptBlock {Get-Process}
  return $Processes
}

$Threads = @()

$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($Computer in $Computers) {
  $RunSpaceObject = [PSCustomObject]@{
    RunSpace = [powershell]::Create()
    Invoker = $null
  }
  $RunSpaceObject.RunSpace.RunSpacePool = $RunSpacePool
  $RunSpaceObject.RunSpace.AddScript($CodeContainer) | Out-Null
  $RunSpaceObject.RunSpace.AddArgument($c) | Out-Null
  $RunSpaceObject.Invoker = $RunSpaceObject.RunSpace.BeginInvoke()
  $Threads += $RunSpaceObject
  $Elapsed = $Stopwatch.Elapsed
  Write-Host "Finished creating runspace for $c. Elapsed time: $Elapsed"
}
$Elapsed = $Stopwatch.Elapsed
Write-Host "Finished creating all runspaces. Elapsed time: $Elapsed"
while ($Threads.Invoker.IsCompleted -contains $false) {}
$Elapsed = $Stopwatch.Elapsed
Write-Host "All runspaces completed. Elapsed time: $Elapsed"

$ThreadResults = @()
foreach ($t in $Threads) {
  $ThreadResults += $t.RunSpace.EndInvoke($t.Invoker)
  $t.RunSpace.Dispose()
}

$RunSpacePool.Close()
$RunSpacePool.Dispose()