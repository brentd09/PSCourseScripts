function ConvertFrom-UnixTimeStamp {
  <#
  .SYNOPSIS
    Converts Unix timestamp to DateTime object
  .DESCRIPTION
    Converts Unix timestamp to DateTime object
  .EXAMPLE
    ConvertFrom-UnixTimeStamp -UnixTimeStamp 1614209521
    Unix time codes are seconds from 1 Jan 1970, this command calculates this
    and turns the result into an object shoing the origial value, the span and
    the PS datetime object 
  .NOTES
    General notes
      Created by:  Brent Denny
      Created on:  24 Feb 2021
      Modified on: 24 Feb 2021
  #>
  Param (
    [parameter(Mandatory=$true)]
    [int]$UnixTimeStamp
  )

  $UnixTimeSpan = New-TimeSpan -Seconds $UnixTimeStamp 
  $UnixStartDate = [datetime]"1 jan 1970"
  $PSDateTimeObj = $UnixStartDate + $UnixTimeSpan
  $ObjHash = @{
    UnixTimeStamp = $UnixTimeStamp
    UnixTimeSpan  = $UnixTimeSpan
    PSDateTime    = $PSDateTimeObj
  }
  New-Object -TypeName psobject -Property $ObjHash
}