<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>
[CmdletBinding()]
Param (
  [srting]$LocalGitPath = 'D:\GIT',
  [pscredential]$Cred =  (Get-Credential -UserName 'Adatum\Administrator' -Message 'Type the password')
)
try {
  $LocalDemoPath = ($LocalGitPath + '\PSCourseAids\DSCDemo\mydemos\WebDemo') -replace '\\{2,}','\'
  $VMs = Get-VM -ErrorAction Stop
  if ($VMs.State -contains "Stopped") {
    $VMs | Where-Object {$_.State -ne 'Running'} | Start-VM
    Write-Host "Waiting for the VMs to start"
    Start-Sleep -Seconds 20
  }
  if ((Get-PSSession).Name -notcontains 'DCsession' -and $VMSessionDC1.VMName -eq '10962C-LON-DC1') {
    $VMSessionDC1 = New-PSSession -VMName '10962C-LON-DC1' -Credential $Cred -Name DCSession
  }
  if ((Get-PSSession).Name -notcontains 'CLsession' -and $VMSessionCL1.VMName -eq '10962C-LON-CL1') {
    $VMSessionCL1 = New-PSSession -VMName '10962C-LON-CL1' -Credential $Cred -Name CLSession
  }
  Copy-Item -Path $LocalDemoPath -Destination 'E:\WebDemo' -Force -ToSession $VMSessionDC1 -Recurse
  Copy-Item -Path $LocalGitPath -Destination 'E:\GIT' -Force -Recurse -ToSession $VMSessionCL1
  Invoke-Command -Session $VMSessionDC1 -ScriptBlock {
    New-SmbShare -Name 'WebDemo' -Path E:\WebDemo
    Set-DnsServerForwarder -IPAddress '8.8.8.8'
  }
}
Catch {
  Write-Warning "An error occured?" 
}