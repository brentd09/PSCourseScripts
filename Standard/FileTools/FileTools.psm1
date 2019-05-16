function Touch-File {
<#
.Synopsis
   UNIX touch 
.DESCRIPTION
   This does the same function as a unix touch command in that any filename listed
   in the -filename parameter will have its LastWriteTime updated to current time 
   or if the file does not exist an empty file will be created.
.EXAMPLE
   Touch-File -FileName test01.tmp,test02a.tmp,fwaw.log

   This example updates or creates all of these files to the current directory
.EXAMPLE
   Touch-File -FileName test01.tmp

   This example only creates or updates this one file
.NOTES
   General notes
   Created by : Brent Denny
   Created on : 15 Mar 2018
#>
  [cmdletbinding()]
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$Filename
  )
  foreach ($File in $Filename ) {
    if (Test-Path $File) {
      try {(Get-ChildItem $File).LastWriteTime = Get-Date -ErrorAction Stop} 
      Catch {Write-Warning "Problem updating file $File"}   
      
    } # end if
    else {
      try {$null | out-file -Append -FilePath $File -ErrorAction stop} 
      Catch {Write-Warning "Problem writing to file $File"}   
    } # end else
  } # end foreach
} #end function