JEA - Just Enough Administration
--------------------------------
JEA sets up (Run-As) Full administration endpoints so that non Full Admin people can be allowed to manage the system that they are remotely connecting to via PS Remoting.
The users can access an endpoint that can be restricted regarding what commands can be executed, what parameters can be used and even what data can be applied to the parameters.
You can use wildcards when setting up the permissions regarding what commands can be executed, i.e. Get-* whould allow all get commands to be executed, as long as the modules, and providers that they use were also allowed.
     

JEA Security Considerations
---------------------------
JEA helps you improve your security posture by reducing the number of permanent administrators on your machines. 
JEA uses a PowerShell session configuration to create a new entry point for users to manage the system. 
Users who need elevated, but not unlimited, access to the machine to do administrative tasks can be granted access to the JEA endpoint.
Since JEA allows these users to run admin commands without having full admin access, you can then remove those users from highly privileged security groups.

Run-As account
--------------
Each JEA endpoint has a designated run-as account. 
This is the account under which the connecting user's actions are executed. 
This account is configurable in the session configuration file, and the account you choose has a significant bearing on the security of your endpoint.

Virtual accounts are the recommended way of configuring the run-as account. 
Virtual accounts are one-time, temporary local accounts that are created for the connecting user to use during the duration of their JEA session. 
As soon as their session is terminated, the virtual account is destroyed and can't be used anymore. 
The connecting user doesn't know the credentials for the virtual account. 
The virtual account can't be used to access the system via other means like Remote Desktop or an unconstrained PowerShell endpoint.

By default, virtual accounts belong to the local Administrators group on the machine. 
This gives them full rights to manage anything on the system, but no rights to manage resources on the network. 
When authenticating with other machines, the user context is that of the local computer account, not the virtual account.

Domain controllers are a special case since there isn't a local Administrators group. 
Instead, virtual accounts belong to Domain Admins and can manage the directory services on the domain controller. 
The domain identity is still restricted for use on the domain controller where the JEA session was instantiated. 
Any network access appears to come from the domain controller computer object instead.

In both cases, you may explicitly define which security groups the virtual account belongs to. 
This is a good practice when the task can be done without local or domain admin privileges. 
If you already have a security group defined for your admins, grant the virtual account membership to that group. 
Virtual account group membership is limited to local security groups on workstation and member servers. On domain controllers, virtual accounts must be members of domain security groups. 
Once the virtual account has been added to one or more security groups, it no longer belongs to the default groups (local or domain admins).

The following table summarizes the possible configuration options and resulting permissions for virtual accounts:

Computer type |	Virtual account group configuration |	Local user context |	Network user context
---|---|---|---
Domain controller |	Default |	Domain user, member of 'DOMAIN\Domain Admins'|	Computer account
Domain controller |	Domain groups A and B |	Domain user, member of 'DOMAIN\A', 'DOMAIN\B' |	Computer account
Member server or workstation |	Default |	Local user, member of 'BUILTIN\Administrators' |	Computer account
Member server or workstation |	Local groups C and D |	Local user, member of 'COMPUTER\C' and 'COMPUTER\D' |	Computer account
<BR><BR>
# HOW TO CREATE A JEA ENDPOINT #

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
     
Connecting to the EndPoint
--------------------------
When a user wishes to connect to the JEA EndPoint they will use one of the following:
* Invoke-Command -ComputerName ServerName -ConfigurationName NameOfEndPoint -scriptblock {<Allowed commands>}
* Enter-PSSession -ComputerName ServerName -ConfigurationName NameOfEndPoint
_The Enter-PSSession may not be allowed as the restrictions on the endpoint may be so tight that a full session may be not possible_     

<BR><BR>
# JEA Information     
     
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

<BR>
# JEA Demo 

<strong>Try the following:</strong> 
<BR>
1. <strong>LON-DC1</strong> - Create a JEA Module folder with a RoleCapabilities sub-directory:<BR>
     ```
     New-Item -ItemType Directory -Force C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities
     Set-Location C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA
     ```
     In the JEA autoload directory:<BR> 
     Create an empty <strong>JEA.psm1 and manifest file:</strong> file<BR>
     ```
     New-Item -Type File -Path .\ -Name JEA.psm1
     New-ModuleManifest -Path C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\JEA.psd1
     ```
2. <strong>LON-DC1</strong> - Create a template RoleCapabilitiesFile:<BR>
     ```
     Set-Location C:\Windows\system32\WindowsPowerShell\v1.0\Modules\JEA\RoleCapabilities
     New-PSRoleCapabilityfile -Path .\JEA_AD_mgmt.psrc
     ```
     Edit this file to configure the following:<BR>
     *   Modules to Import
     *   VisibleCmdlets
     *   VisibleFunctions
     *   Visible External Commands
     *   Etc.
3. <strong>LON-DC1</strong> - Create a JEA SessionConfig file:<BR>
     ```
     New-PSSessionConfigurationFile -Path .\JEA_AD_mgmt.pssc -Full 
     # In the RoleCapabilities directory for ease of mgmt
     ```
     Edit this file to configure the following:<BR>
     *  SessionType
     *  TranscriptDirectory   (make sure this directory exists on the target machine)
     *  RunAsVirtualAccount
     *  RoleDefinitions (setup a user or group as DOM\GRP and then add the capability name(e.g. JEA_AD_mgmt), this is autodiscovered)
4. <strong>LON-DC1</strong> - Register an endpoint on the target machine:<BR>
     ```
     Register-PSSessionConfiguration -Name NameofEndpoint -Path .\JEA_AD_mgmt.pssc
     #Only the PSSessionConfigurationFile path is required, as it locates the .psrc files automatically
     ```
5. <strong>LON-CL1</strong> - Test JEA:<BR>
     Switch to the LON-CL1 client VM </Strong><BR>
     Login as the user listed in the .\JEA_AD_mgmt.pssc file, this user needs no special windows permissions<BR>
     Try the allowed command and one that was not allowed:
     ```
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Allowed Cmdlet} -ConfigurationName NameofEndpoint
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Blocked Cmdlet} -ConfigurationName NameofEndpoint
     ```
     Change the .psrc file on LON-DC1 to include second cmdlet, then re-run the invoke-command<BR>
     ```
     # Edit the .psrc file to allow another cmdlet and you will see it is allowed without re-registration
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Newly Allowed Cmdlet} -ConfigurationName NameofEndpoint
     ```
     Try running the invoke-command without specifying the endpoint:
     ```
     Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Allowed Cmdlet}
     # This will fail for a non admin user
     ```
6. <strong>LON-DC1</strong> - Check Capability of a user:<BR>
     ```
     Get-PSSessionCapability -ConfurationName NameofEndpoint -UserName DOM\USER
     ```
7. <strong>LON-DC1</strong> - Check SessionConfig settings:<BR>
     ```
     Get-PSSessionConfiguration -Name NameofEndpoint
     ```
     
FINISHED!
