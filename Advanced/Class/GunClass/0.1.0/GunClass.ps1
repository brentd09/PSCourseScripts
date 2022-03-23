<#
.SYNOPSIS
  Simple Class example with hidden property
.DESCRIPTION
  This shows how a simple class can be set up with properties and
  methods
.EXAMPLE
  GunClass.ps1 -MagazineCapacity 17
  Creates an object for a Glock pistol with properties and methods
.INPUTS
  Integer
.OUTPUTS
  Glock object
.NOTES
  General notes
    Created by:   Brent Denny
    Created on:   16-May-2019
    Last Changed: 24-MAr-2022
  
  Change Log
    Version   Date            Modifications
    0.0.0     16-May-2019     The gun class was produced to help the students 
                              understand how a class works and how to build 
                              constructors and methods
    0.1.0     24-Mar-2022     A parameter was added, the action in the object 
                              was added to help see what actions were taking 
                              place during the script, and the hidden attribute
                              was added showing how to hide a property. 
                              Note: "Get-Member -Force" can show the hidden property                        
#>
[cmdletBinding()]
Param ([int]$MagazineCapacity = 17)

# Class
Class Glock {
  [string]$AmmoType
  [int] hidden $CartridgeCapacity
  [int]$LiveBulletsInCartridge
  [string]$FireAttempt
  [string]$Action

  Glock ($Capacity) {
    $this.AmmoType = '9mm'
    $this.CartridgeCapacity = $Capacity
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
    $this.Action = 'New'
  }

  [Glock]Reload () {
    $this.LiveBulletsInCartridge = $this.CartridgeCapacity
    $this.FireAttempt = "NA"
    $this.Action = 'Reload'
    return $this
  }

  [Glock]Fire () {
    if ($this.LiveBulletsInCartridge -ge 1) {
      $this.LiveBulletsInCartridge = $this.LiveBulletsInCartridge - 1
      $this.FireAttempt = "BANG"
      $this.Action = 'Fire'
      return $this
    }
    else {
      $this.FireAttempt = "CLICK"
      $this.Action = 'Fire'
      return $this
    }
  }

  [Glock]Status () {
    $this.FireAttempt = "NA"
    $this.Action = 'Status'
    return $this
  }

  [Glock]Unload () {
    $this.LiveBulletsInCartridge = 0
    $this.FireAttempt = "NA"
    $this.Action = 'Unload'
    return $this
  }
}


$HandGun = [Glock]::New($MagazineCapacity) 
$HandGun.Status()
$HandGun.Reload()
$HandGun.Fire()
$HandGun.Fire()
$HandGun.Unload() 
$HandGun.Fire() 
