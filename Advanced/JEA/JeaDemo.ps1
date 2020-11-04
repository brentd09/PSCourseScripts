# JEA Demo 

#Try the following

#LON-DC1
 # Create a JEA Module folder with a RoleCapabilities sub-directory
     New-Item -ItemType Directory -Force C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities
     Set-Location C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA

 # In the JEA autoload directory
  # Create an empty <strong>JEA.psm1 and manifest file
   
     New-Item -Type File -Path .\ -Name JEA.psm1
     New-ModuleManifest -Path C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\JEA.psd1 -RootModule .\JEA.psm1
   
# LON-DC1
 # Create a template RoleCapabilitiesFile
    
     Set-Location C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities
     New-PSRoleCapabilityfile -Path .\JEA_AD_mgmt.psrc
   
 # Edit this file to configure the following
  #  Modules to Import
  #  VisibleCmdlets
  #  VisibleFunctions
  #  Visible External Commands (Make sure you include the full path to the external command)
  #  Etc.

# LON-DC1
 # Create a JEA SessionConfig file
   
     New-PSSessionConfigurationFile -Path .\JEA_AD_mgmt.pssc -Full 
     # In the RoleCapabilities directory for ease of mgmt
   
 # Edit this file to configure the following
  # SessionType
  # TranscriptDirectory   (make sure this directory exists on the target machine)
  # RunAsVirtualAccount
  # RoleDefinitions (setup a user or group as DOM\GRP and then add the capability name(e.g. JEA_AD_mgmt), this is autodiscovered)

# LON-DC1 Register an endpoint on the target machine
    
     Register-PSSessionConfiguration -Name NameofEndpoint -Path .\JEA_AD_mgmt.pssc
     #Only the PSSessionConfigurationFile path is required, as it locates the .psrc files automatically
    
# LON-CL1
 # Test JEA
  # Switch to the LON-CL1 client VM
  # Login as the user listed in the .\JEA_AD_mgmt.pssc file, this user needs no special windows permissions
  # Try the allowed command and one that was not allowed:

     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Allowed Cmdlet} -ConfigurationName NameofEndpoint
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Blocked Cmdlet} -ConfigurationName NameofEndpoint

  # Change the .psrc file on LON-DC1 to include second cmdlet, then re-run the invoke-command

  # Edit the .psrc file to allow another cmdlet and you will see it is allowed without re-registration
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Newly Allowed Cmdlet} -ConfigurationName NameofEndpoint

  # Try running the invoke-command without specifying the endpoint:

     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Allowed Cmdlet}
  # This will fail for a non admin user
  
# LON-DC1
 # Check Capability of a user
     
     Get-PSSessionCapability -ConfurationName NameofEndpoint -UserName DOM\USER
     
# LON-DC1
 # Check SessionConfig settings
 
     Get-PSSessionConfiguration -Name NameofEndpoint
 