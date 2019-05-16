<#
.SYNOPSIS
    Traces what PowerShell is doing in the background.
.DESCRIPTION
    The Trace-Command can trace the background processing for any of the following, regarding cmdlets and 
    pipelines. This command gives great insight into the actual working of the ByValue/ByPropertyName 
    object/parameter binding across the pipeline.
    This script will use the Get-TraceSource command to get all of the Trace Names as seen below, and then
    will use them in the Trace-Command to check all of the traceable events.
    
    Trace Names
    -----------
    CertificateProvider
    CmdletProviderClasses
    CmdletProviderContext
    CommandDiscovery
    CommandHelpProvider
    CommandSearch
    ConsoleControl
    ConsoleHost
    ConsoleHostRunspaceInit
    ConsoleHostUserInterface
    ConsoleLineOutput
    DisplayDataQuery
    ETS
    FileSystemContentStream
    FileSystemProvider
    FormatFileLoading
    FormatViewBinding
    GetHelpCommand
    InternalDeserializer
    LocationGlobber
    MemberResolution
    Modules
    MshSnapinLoadUnload
    NavigationCommands
    ParameterBinderBase
    ParameterBinderController
    ParameterBinding
    PathResolution
    PSDriveInfo
    PSSnapInLoadUnload
    RegistryProvider
    RunspaceInit
    SessionState
    TypeConversion
    TypeMatch
.NOTES
    General notes
      Written:
        By: Brent Denny
        On: 20 Nov 2018
#>
[CmdletBinding()]
Param()
$TrcSrc = (Get-TraceSource).name
Trace-Command -Name $TrcSrc -Expression {"bits" | get-service } -PSHost