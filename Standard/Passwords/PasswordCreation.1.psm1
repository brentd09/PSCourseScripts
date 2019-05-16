function Get-ComplexPassword {
<#
.Synopsis
   Create Complex Password
.DESCRIPTION
   This script creates complex passwords based on the parameters 
   given. Parameters can be set for the number of UpperCase
   LowerCase, Numbers and Special characters you want in the 
   generated password. The numbers only include 2 through 9 so
   that there can not be any mistaking a lowercase L and an 
   Uppcase o. 
   This version of the script shows how to achieve the function's 
   result via a class constructor.
.EXAMPLE
   Get-ComplexPassword -Numbers 1 -Uppercase 2 -Lowercase 5 -Special 1
.EXAMPLE
   Get-ComplexPassword
.NOTES
   General notes
   Created:
   By: Brent Denny
   On: 26 Apr 2019
#>
  [cmdletbinding()]
  Param (
    [int]$Numbers = 2,
    [int]$Uppercase = 2,
    [int]$Lowercase = 5,
    [int]$Special = 1
  )

  Class ComplexPassword {
     [string]$ComplexPswd

     ComplexPassword ([int]$NumberCount,[int]$UppercaseCount,[int]$LowercaseCount,[int]$SpecialCount) {
      do {
         $Num = 2..9 | get-random -Count $NumberCount
         $Upr = 65..90 | ForEach-Object {[char]$_} | get-random -count $UppercaseCount
         $Lwr = 97..122 | ForEach-Object {[char]$_} | get-random -count $LowercaseCount
         $Spl = 33,35,36,37,38,63,64  | ForEach-Object {[char]$_} | get-random -count $SpecialCount
         $RawPswd = $Num + $Upr + $Lwr + $Spl
         $RandPswd = $RawPswd | Sort-Object {Get-Random}
         $this.ComplexPswd = -join ($RandPswd)
       } until ($this.ComplexPswd -match '^[a-z]')
     }
  }

$NewPassword = [ComplexPassword]::New($Numbers,$Uppercase,$Lowercase,$Special)
return $NewPassword
}

