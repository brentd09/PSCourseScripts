<#
.SYNOPSIS
  Sets up the push DSC demo for class 
.DESCRIPTION
  This sets up the required files to perform a DSC Demo, on the DC1 it creates the WebDemo Directory,
  creates a share with the same name and then copies the html file into the share.
  On the CL1 VM it creates a DSCCemo Directory and copies the DSC Config script here.
  It will also remove the IIS role from SVR1 server and remove the wwwroot directory as well to 
  start with a 'clean slate' on that server, proving that the DSC has performed the work to install 
  the web site.  
.EXAMPLE
  Setup-Demo.ps1
.NOTES
  General notes
#>
[CmdletBinding()]
Param (
  [PSCredential]$Creds = (Get-Credential  -UserName 'ADATUM\Administrator' -Message 'Enter the VM Administrator password')
)
try {
  $SessionToCreateShare = New-PSSession -VMName '10962C-LON-DC1' -Credential $Creds 
  Invoke-Command -Session $SessionToCreateShare -ScriptBlock {
    if (-not (test-path 'C:\WebDemo')) {New-Item -ItemType Directory -Name 'WebDemo' -Path 'c:\' -Force}
    if (-not (test-path '\\lon-dc1\WebDemo')) {New-SmbShare -Name 'WebDemo' -Path 'c:\WebDemo'  -ReadAccess 'everyone' }
  } 
  Copy-Item -ToSession $SessionToCreateShare -Path 'D:\GIT\pscoursescripts\Advanced\DSCDemo\mydemos\WebDemo\index.html' -Destination 'c:\WebDemo\' -Force -ErrorAction stop
}  
catch {Write-Warning 'The DC1 share creation failed';break}
try {
  $SessionToCopyConfig = New-PSSession -VMName '10962C-LON-CL1' -Credential $Creds 
  Invoke-Command -Session $SessionToCopyConfig  -ScriptBlock {
    if (-not (test-path 'C:\DSCDemo')) {New-Item -ItemType Directory -Name 'DSCDemo' -Path 'c:\' -Force}
  } 
  Copy-Item -ToSession $SessionToCopyConfig -Path 'D:\GIT\pscoursescripts\Advanced\DSCDemo\mydemos\DSCDemo\DSCConfig.ps1' -Destination 'c:\DSCDemo\' -Force  -ErrorAction stop
}  
catch {Write-Warning 'The config copy failed';break}
try {
  $SessionToDelIIS = New-PSSession -VMName '10962C-LON-SVR1' -Credential $Creds 
  Invoke-Command -Session $SessionToDelIIS -ScriptBlock {
    $IISState = Get-WindowsFeature -Name web-server
    if ($IISState.Installed -eq $true) {
      Remove-WindowsFeature -Name web-server -ErrorAction stop
      Remove-Item -Recurse -Path 'c:\inetpub\wwwroot\*'
      Restart-Computer
    }
  } 
}  
catch {Write-Warning 'The IIS removal failed';break}