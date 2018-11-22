# Create new directory
New-Item -ItemType Directory -Force C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RolCapabilities
# Go to new directory
Set-Location C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RolCapabilities
# Create Role Capability File
New-PSRoleCapabilityFile -Path .\JEA_AD_mgmt.psrc -ModulesToImport ActiveDirectory -VisibleCmdlets Get-ADUser -Author Brent -Description 'This locks down remote access'
# Create Session Configuration File
New-PSSessionConfigurationFile -Path .\JEA_AD_mgmt.pssc -Author Brent -SessionType RestrictedRemoteServer -RunAsVirtualAccount -Full
# Edit file
notepad .\JEA_AD_mgmt.pssc #Modify the TranscriptDirectory,RoleDefinitions,ExecutionPolicy etc
# Register Endpoint that the remote person will connect to
Register-PSSessionConfiguration -Name AD_ADMIN_RO -Path .\JEA_AD_mgmt.pssc
# Unregister and re-register Endpoint after a change to  Session Configuration File
Unregister-PSSessionConfiguration -Name AD_ADMIN_RO
Register-PSSessionConfiguration -Name AD_ADMIN_RO -Path .\JEA_AD_mgmt.pssc