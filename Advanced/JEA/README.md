JEA - Just Enough Administration
--------------------------------
JEA is simple to configure as long as you know a few key things. <BR>
You need to configure a PSRoleCapabilityFile and a PSSessionConfiguationFile. The Capability 
file needs to be discoverable as discussed later. The PSSessionConfigurationFile links to the 
PSRoleCapabilityFile when Registering and EndPoint.
JEA sessions natively do not allow GUI tools to run. so you need to create functions for the 
sub admins to do their work.

Create the JEA Module path
--------------------------
Create the following, (on the target machine):
<strong>C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities</strong>  
Populate the JEA folder with a JEA.psm1 file containing the functions that JEA connections will use.<BR>
Next you will need to create a module manifest file using: <br>
<strong>New-ModuleManifest -Path {ModulePath}\JEA.psd1 -RootModule {ModulePath}\JEA.psm1</strong><BR>
Also populate the <strong>RoleCapabilities</strong> sub-directory with all of the <strong>.psrc</strong> files for this target, this keeps 
the files centrally managed and makes the modules and RoleCapabilities auto discoverable.

The PSCapabilityFile dictates the folowing:<BR>
Modules to Import<BR>
visible cmdlets <BR>
visible functions<BR>
visible aliases<BR>
Visible External Commands<BR>
and more.<BR>

PSCapabilityFile
----------------
The PSCapabilityFile will dictate what is available to the user when they connect. For example: which cmdlets, functions, ext commands etc are visable. A skeleton template file can be created by using the PS CmdLet: <BR>
This file must be created in a RoleCapabilities sub folder of the module autoloader path for example:
<strong>CD C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities</strong> <BR>
<strong>New-PSRoleCapabilityfile -Path .\JEA_AD_mgmt.psrc</strong> <BR>
It must be saved with a <strong>.psrc</strong> extension.

PSSessionConfigurationFile
--------------------------
The PSSessionConfigurationFile does not need to be installed anywhere special because
when you register an endpoint you call the file using a path. It must be saved with a 
<strong>.pssc</strong> extension. <BR>
I would however store it, as a best practice in the {ModulePath}\RoleCapabilities folder
this helps centralise the files <BR>
A skeleton template can be created by using:<BR>
<strong>New-PSSessionConfigurationFile -Path .\JEA_AD_mgmt.pssc -Full</strong><BR>

The PSSessionConfigurationFile will dictate the following:<BR>
RoleDefinitions      -> Which users/groups get which autolocated RoleCapabilityFile.<BR>
SessionType          -> Default or RestrictedRemote (later is preffered as it restricts as default)<BR>
TransscriptDirectory -> Where to dump the transcript files<BR>
RunAsVirtualAccount  -> Create a onetime/PSSession local user linked to your account so that accidents are contained to that machine only<BR>
ExecutionPolicy      -> Policy applied to the session<BR>
and more.<BR>

Register an EndPoint
--------------------
With these two files on a target server you can now register an EndPoint using:<BR>
_(Assuming you are in the folder where the pssc file exists)_     
<strong>Register-PSSessionConfiguration -Name NameofEndpoint -Path .\PSSessionConfigFile.pssc -force</strong><BR>
In the process of registering the endpoint the SessionconfiguartionFile will autolocate the 
PSRoleCapabilityFile that was saved in the RoleCapabilities folder in a Module directory under a 
Modules directory (This is how it is auto located).

PSRoleCapability File Changes
-----------------------------------
If you edit the Role Capabilities file the person using the remote session to this machine would need to kill the remote session and remake a new session to see the new capabilities come into effect! You do not have to re-register the endpoint.

GUI Tool
--------
Show the JEA Helper Tool v2

JEA Permissions
---------------
When using JEA ordinary users that have been givien the access to commands can use these commands as if they were administrators. For example a normal user 'BOB' if given the rights to use Set-ADUser can user that command to change user's details.<br>
<strong>So be careful which commands someone is given</strong>

JEA Demo for training
---------------------
I think it will be best not to cover the JEA subject from the courseware from 10962C as the information
in the course is hard to follow if you do not have a good big picture regarding how JEA actually works.

So in teaching this I suggest that we go through a demo like the following:<BR>
1. <strong>LON-DC1</strong> - Create a JEA Module folder with a RoleCapabilities sub-directory:<BR>
     <strong>New-Item -ItemType Directory -Force C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities</strong><BR>
     In the JEA autoload directory:<BR> 
     Create an empty <strong>JEA.psm1</strong> file<BR>
     Create a manifest file using: <BR>
     <strong>New-ModuleManifest -Path C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\JEA.psd1</Strong>
2. <strong>LON-DC1</strong> - Create a template RoleCapabilitiesFile:<BR>
     <strong>New-PSRoleCapabilityfile -Path .\JEA_AD_mgmt.psrc</strong> (in the RoleCapabilities directory) 
     Edit this file to configure the following:<BR>
        Modules to Import<BR>
        VisibleCmdlets<BR>
        VisibleFunctions<BR>
        Visible External Commands<BR>
3. <strong>LON-DC1</strong> - Create a JEA SessionConfig file:<BR>
     <strong>New-PSSessionConfigurationFile -Path .\JEA_AD_mgmt.pssc -Full</strong> (in the RoleCapabilities directory for ease of mgmt)
     Edit this file to configure the following:<BR>
       SessionType<BR>
       TranscriptDirectory   (make sure this directory exists on the target machine)<BR>
       RunAsVirtualAccount<BR>
       RoleDefinitions (setup a user or group as DOM\GRP and then add the capability name(e.g. JEA_AD_mgmt), this is autodiscovered)<BR>
4. <strong>LON-DC1</strong> - Register an endpoint on the target machine:<BR>
     <strong>Register-PSSessionConfiguration -Name NameofEndpoint -Path .\JEA_AD_mgmt.pssc</strong>
     (Only the PSSessionConfigurationFile path is required, as it locates the .psrc files automatically)<BR>
5. <strong>LON-CL1</strong> - Test JEA:<BR>
     Run the following:
       Login user (the user listed in the .\JEA_AD_mgmt.pssc file, this user needs no special windows permissions)<BR>
       <strong>Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Allowed Cmdlet} -ConfigurationName NameofEndpoint</strong><BR>
       <strong>Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Blocked Cmdlet} -ConfigurationName NameofEndpoint</strong><BR>
       Change the .psrc file on LON-DC1 to include second cmdlet, then re-run previous two invoke-commands
       Try running the Invoke-Command without the -ConfigurationName NameOfEndpoint (it will fail)<BR>
6. <strong>LON-DC1</strong> - Check Capability of a user:<BR>
     <strong>Get-PSSessionCapability -ConfurationName NameofEndpoint -UserName DOM\USER</strong><BR>
7. <strong>LON-DC1</strong> - Check SessionConfig settings:<BR>
     <strong>Get-PSSessionConfiguration -Name NameofEndpoint</strong><BR>
     
FINISHED!
