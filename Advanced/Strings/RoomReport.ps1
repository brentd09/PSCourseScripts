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
  
$RoomReport = Import-Csv $FilePath | Select-Object -Property CourseName,
                                                             Duration,
                                                             Type,
                                                             Instructor,
                                                             Room,
                                                             @{n='StartDate';e={$_.StartDate -as [datetime]}},
                                                             @{n='EndDate';e={$_.EndDate -as [datetime]}},
                                                             MaxStudents,
                                                             NumBoookings,
                                                             RemoteStudents,
                                                             RemoteBookings1,
                                                             TP_Type,
                                                             StatusName
$RoomReport
$CurrentDate = Get-Date
$MondayCorrection = 0 - ($CurrentDate.DayOfWeek.value__ - 1)
$MondayDate = $CurrentDate.AddDays($MondayCorrection)
$FridayDate = $MondayDate.AddDays(4)
