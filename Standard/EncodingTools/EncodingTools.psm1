function ConvertTo-Base64 {
  Param (
    [Parameter(Mandatory=$true)]
    [string]$TextToConvert
  )
  $Bytes = [System.Text.Encoding]::UTF8.GetBytes($TextToConvert)
  $Base64 = [System.Convert]::ToBase64String($Bytes)
  $ObjProp = [ordered]@{
    Text = $TextToConvert
    Base64 = $Base64
  }
  New-Object -TypeName psobject -Property $ObjProp
}

function ConvertFrom-Base64 {
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Base64String
  )
  $Bytes = [System.Convert]::FromBase64String($Base64String)
  $EncodingType = [System.Text.Encoding]::ASCII
  $ASCIIString = $EncodingType.GetString($Bytes)
  $ObjProp = [ordered]@{
    Text = $ASCIIString
    Base64 = $Base64String
  }
  New-Object -TypeName psobject -Property $ObjProp
}

function Convert-AsciiToText {
  <#
  .SYNOPSIS
    Convert ASCII integers in an array into text
  .DESCRIPTION
    The ASCII integeger array is entered into the AsciiCodes parameter and the
    script will look for any codes that match printable characters. If there 
    are integers that do not match printable characters then the script displays
    a grey dot on the screen
  .EXAMPLE
    Convert-AsciiToText -AsciiCodes ((Get-CimInstance -Namespace root\wmi -ClassName mssmbios_rawsmbiostables).smbiosdata) -ScreenWidth 80
    This will look in the raw BIOS information and display and strings it finds from the result of this command
  .NOTES
    General notes
    Created by: Brent Denny
    Created on: 29 Mar 2019
  #>
  [cmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [int[]]$AsciiCodes,
    [int]$ScreenWidth = 80
  )
  $Count = 0
  [int[]]$SpecialChar = @(33..47+58..64+91..96+123..126)
  $AlphaNumeric = @(48..57+65..90+97..122)
  foreach ($Val in $AsciiCodes) {
    if ($Val -notin $AlphaNumeric -and $val -notin $SpecialChar) {
      write-host -NoNewline "." -ForegroundColor DarkGray
    }
    else {
      $Char = [char]$Val
      Write-Host -NoNewline $Char -ForegroundColor white
    }
    $Count++
    if ($Count -ge $ScreenWidth -and $ScreenWidth -ne 0) {
      $Count = 0
      Write-Host
    }
  }
}