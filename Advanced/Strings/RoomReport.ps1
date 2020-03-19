<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>
[CmdletBinding()]
Param (
  [string]$FilePath = 'c:\qld.csv'
)
  
$RoomReport = Import-Csv $FilePath | Select-Object -Property   Room,
  CourseName, 
  @{n='Duration';e={$_.Duration -as [int]}},
  @{n='Trainer';e={if ($_.Instructor -ne 'Not Assigned'){$_.Instructor -replace '^(\w+)\s+(\w)\w+','$1$2'}else{'NA'}}},
  @{n='StartDate';e={$_.StartDate -as [datetime]}},
  @{n='EndDate';e={$_.EndDate -as [datetime]}},
  @{n='Bookings';e={"$($_.NumBookings)L $($_.RemoteStudents)T $($_.RemoteBookings1)Z"}}
$CurrentDate = Get-Date -Hour 0 -Minute 0 -Second 0
$MondayCorrection = 0 - ($CurrentDate.DayOfWeek.value__ - 1)
$MondayDate = ($CurrentDate.AddDays($MondayCorrection)).AddSeconds(-1)
$FridayDate = ($MondayDate.AddDays(4)).AddSeconds(1)
$RoomReport  | 
 Where-Object {$_.StartDate -ge $MondayDate -and $_.StartDate -le $FridayDate }  | 
 Sort-Object -Property Room,StartDate |
 Select-Object -Property *,@{n='Start';e={$_.StartDate.toShortDateString()}},@{n='End';e={$_.EndDate.toShortDateString()}}  -ExcludeProperty StartDate,EndDate |
 Format-Table
