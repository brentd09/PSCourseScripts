$Outer = 1..100
$Inner = 1..10

foreach ($Out in $Outer) {
  Write-Progress -Id 1 -Activity "Doing the Outer stuff" -PercentComplete ($Out/$Outer[-1]*100) -Status "Doing some cool stuff"
  foreach ($In in $Inner) {
  Write-Progress -ID 2 -ParentId 1 -Activity "Doing the Inner stuff" -PercentComplete ($In/$Inner[-1]*100) -Status "$($In/$Inner[-1]*100)% Complete"
  1..20 | ForEach-Object {Write-Progress -ParentId 2 -Activity "Doing the Count" -PercentComplete ($_/20*100) -CurrentOperation "Current Number $_" -Status "Counting" ; Start-Sleep -Milliseconds 100 }
  start-sleep -Milliseconds 100  
  } 
}