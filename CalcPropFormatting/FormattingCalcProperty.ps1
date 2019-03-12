<#
    This is a demo of different ways to have the calculated property show up with the correct formatting 
    without destroying the original object as Format-Table does!
#>

get-volume | 
  Where-Object {$_.DriveType -eq "Fixed"} |
  Format-Table -Property  DriveLetter,
                        @{n="SpaceUsed(GB)";e={"{0:N2}" -f (($_.size - $_.sizeremaining) / 1GB)};a="right"}

get-volume | 
  Where-Object {$_.DriveType -eq "Fixed"} |
  Select-Object -Property DriveLetter,@{n="SpaceUsed(GB)";e={("{0:N2}" -f (($_.size - $_.sizeremaining) / 1GB)) -as [double]}} 