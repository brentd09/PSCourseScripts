<#
.SYNOPSIS
  Copies a directory from the LON-CL1 VM to your host PC
.DESCRIPTION
  This script copies a directory from the CL1 VM in the 
  10961C or 2C Poweshell courses to a folder on the Host 
  Machine. The Default locations are E:\Myfiles on the VM
  to D:\Myfiles on the host machine. These can be changed
  as paramters to the command.
.EXAMPLE
  Get-VMFiles 
  This uses the default local and VM paths to copy the files
.EXAMPLE
  Get-VMFiles -LocalDir C:\test -VMDir E:\Files
  This copies all of the contents of the VM directory 
  E:\Files to the local drive C:\test
.NOTES
  General notes
  Created by Brent Denny
  Created on 8 Jun 2018
#>
[CmdletBinding()]
Param(
  [string]$LocalDir = "D:\MyFiles",
  [string]$VMDir = "E:\MyFiles",
  [pscredential]$Cred = (Get-Credential -Message "Enter Password of the VM user" -UserName "Adatum\Administrator")
)
$VMFullPath = ("$VMDir"+"\*") -replace '\\{2,}','\'
Write-Host -ForegroundColor Yellow "***** Please copy all of your scripts to $VMDir on the VM before prceeding *****"
Read-Host "Press ENTER to continue"
try {
  $VMSession = New-PSSession -VMName 10961C-LON-CL1 -Credential $Cred -ErrorAction stop
  if (-not (Test-Path $LocalDir)) {
    New-Item -Path $LocalDir -ItemType Directory -ErrorAction Stop
  }
}
Catch {
  Write-Warning "There was a problem with the Session or directory creation"
  Break
}
$SrcDirValid = Invoke-Command -Session $VMSession -ScriptBlock {Test-Path $using:VMDir}
if ($SrcDirValid -eq $true) {
  Copy-Item -FromSession $VMSession -Path $VMFullPath -Destination $LocalDir -Recurse
}