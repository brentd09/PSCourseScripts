<#
.SYNOPSIS
  This uses class methods to test if IPs are on the same subnet 
.DESCRIPTION
  This will take two IP addresses, the local is entered as a CIDR address 
  and the second IP address is just entered in as an IP address ad then 
  it will determine if they are on the same subnet or not
.EXAMPLE
  Invoke-IPTest.ps1 -CidrAddress 180.2.3.1/16 -AnotherIP 180.4.1.1
  This will test if these two addresses given the 16 bit mask are
  on the same subnet or not
.PARAMETER CidrAddress
  This is the local address and mask length submitted like 173.4.33.1/16
.PARAMETER AnotherIP
  This is the IP address that needs to be compared to the Cidr Address
.NOTES
  General notes
    Created by:  Brent Denny
    Created on:  22 Jun 2021
    Modified on: 22 Jun 2021
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [validatePattern('^([1-9]|[1-9][0-9]|1[01][0-9]|12[0-6]|12[89]|1[3-9][0-9]|2[0-2][0-3])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}\/([1-9]|[12][0-9]|30)$')]
  [string]$CidrAddress,
  [Parameter(Mandatory=$true)]
  [validatePattern('^([1-9]|[1-9][0-9]|1[01][0-9]|12[0-6]|12[89]|1[3-9][0-9]|2[0-2][0-3])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$')]
  [string]$AnotherIP 
)

class IP4Addr {
  [string]$Address
  [string]$Mask
  [int]$MaskLength

  IP4Addr($CIDRAddress) {
    If ($CIDRAddress -notmatch '^([1-9]|[1-9][0-9]|1[01][0-9]|12[0-6]|12[89]|1[3-9][0-9]|2[0-2][0-3])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}\/([1-9]|[12][0-9]|30)$') {$CIDRAddress = '127.0.0.1/8'}
    $CIDRMask  = ($CIDRAddress -split '/')[1] -as [int]
    $BinaryOctets = (("1" * $CIDRMask) + ("0" * (32 - $CIDRMask)) -replace '([01]{8})([01]{8})([01]{8})([01]{8})','$1,$2,$3,$4') -split ','
    $DecimalMask = ($BinaryOctets | ForEach-Object {[convert]::ToInt32($_,2)}) -join '.'
     
    $this.Address    = ($CIDRAddress -split '/')[0]
    $this.Mask       = $DecimalMask
    $this.MaskLength = $CIDRMask
  }

  [bool]LocalSubnetTest ([string]$OtherIPAddress) {
    $OtherIPOctets  = $OtherIPAddress -split '\.'
    $LocalIPOctets   = $this.Address -split '\.'
    $MaskOctets      = $this.Mask -split '\.'
    $MyIPAndResult   = (0..3 | ForEach-Object {$LocalIPOctets[$_] -band $MaskOctets[$_]}) -join '.'
    $OtherAndResult = (0..3 | ForEach-Object {$OtherIPOctets[$_] -band $MaskOctets[$_]}) -join '.'
    if ($MyIPAndResult -eq $OtherAndResult) {return $true}
    else {return $false}
  }
}
$IPObj = [ip4Addr]::New($CidrAddress)
if ($IPObj.LocalSubnetTest($AnotherIP) -eq $true)  {Write-Host -ForegroundColor Cyan "$($IPObj.Address) and $AnotherIP are on the same subnet"} 
else {Write-Host -ForegroundColor Red "$($IPObj.Address) and $AnotherIP are not on the same subnet"} 