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
   
   The defaults are:
   Uppercase : 2 Characters
   Lowercase : 5 Characters
   Numbers   : 2 Numbers
   Special   : 1 Character
.EXAMPLE
   Get-ComplexPassword -NumberCount 1 -UpperCount 2 -LowerCount 5 -SpecialCount 1
.EXAMPLE
   Get-ComplexPassword
.NOTES
   General notes
   Created:
   By: Brent Denny
   On: 10 Oct 2017
#>
  [cmdletbinding()]
  Param (
    [int]$NumberCount = 2,
    [int]$UpperCount = 2,
    [int]$LowerCount = 5,
    [int]$SpecialCount = 1
  )
  do {
    $Num = 2..9 | get-random -Count $NumberCount
    $Upr = 65..90 | ForEach-Object {[char]$_} | get-random -count $UpperCount
    $Lwr = 97..122 | ForEach-Object {[char]$_} | get-random -count $LowerCount
    $Spl = 33,35,36,37,38,63,64  | ForEach-Object {[char]$_} | get-random -count $SpecialCount
    $RawPswd = $Num + $Upr + $Lwr + $Spl
    $RandPswd = $RawPswd | Sort-Object {Get-Random}
    $ComplexPswd = -join ($RandPswd)
  } until ($RandPswd[0] -match '[a-z]')
  return $ComplexPswd 
}