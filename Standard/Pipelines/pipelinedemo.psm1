function Get-OpenTCPPortByPN {
  <#
  .Synopsis
     Tests to see a given TCP port is open on remote computers 
  .DESCRIPTION
     This is a test command to show how pipeline by property name works
  .EXAMPLE 
     Get-ADComputer -filter * | Get-OpenTCPPortByPN
     Piping the AD Computer object will not work By Value, so it will fall
     back to By PropertyName and pass the name property to this command.
     The "Name" parameter from the Get-ADComputer command will be passed 
     across the pipeline to this command, so that this command can then 
     check if the given TCP port is open on each remote computer.  
  .EXAMPLE 
     Get-ADComputer -filter * | Get-OpenTCPPortByPN -TcpPort 443
     Piping the AD Computer object will not work By Value, so it will fall
     back to By PropertyName and pass the name property to this command.
     The "Name" parameter from the Get-ADComputer command will be passed 
     across the pipeline to this command, so that this command can then 
     check if the 443 TCP port is open on each remote computer.  
  .PARAMETER Name
     This refers to the name of the computer and will accept only pipeline
     data via By PropertyName.
  .NOTES
     General notes
     This is a demonstration command that shows how the properties are 
     passed accross the pipeline "By PropertyName".

     Created by: Brent Denny
     Created on: 25 Sep 2023
  #>
  [cmdletbinding()]
  Param (
    [Parameter(DontShow, Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]$Name,
    [int]$TcpPort = 445
  )
  BEGIN {}
  PROCESS {
    foreach ($ComputerName in $Name) {
      $TestPort = Test-NetConnection -ComputerName $ComputerName -Port $TcpPort -InformationLevel Quiet 2>$null 3>$null 4>$null 5>$null
      if ($TestPort -eq $true) {
        [PScustomobject]@{ComputerName=$ComputerName;TcpPort=$TcpPort;State="Open"}
      }
      else {
        [PScustomobject]@{ComputerName=$ComputerName;TcpPort=$TcpPort;State="Blocked"}
      }
    }
  }
  END{}
} 

function Get-OpenTCPPortByVal {
  <#
  .Synopsis
     Tests to see a given TCP port is open on remote computers 
  .DESCRIPTION
     This is a test command to show how pipeline by value works
  .EXAMPLE 
     Get-ADComputer -filter * | Get-OpenTCPPortByVal
     Piping the AD Computer object will work By Value, so it will pass
     the entire ADComputer object to this command so that this command 
     can then check if the given TCP port is open on each remote computer.  
  .EXAMPLE 
     Get-ADComputer -filter * | Get-OpenTCPPortByVal -TcpPort 443
     Piping the AD Computer object will work By Value, so it will pass
     the entire ADComputer object to this command so that this command 
     can then check if the 443 TCP port is open on each remote computer.  
  .PARAMETER Computer
     This refers to the the AD Computer object and will accept only 
     pipeline data via By Value.
  .NOTES
     General notes
     This is a demonstration command that shows how the objects are 
     passed accross the pipeline "By Value".

     Created by: Brent Denny
     Created on: 25 Sep 2023
  #>
  [cmdletbinding()]
  Param (
    [Parameter(DontShow, Mandatory, ValueFromPipeline)]
    [Microsoft.ActiveDirectory.Management.ADComputer[]]$Computer,
    [int]$TcpPort = 445
  )
  BEGIN {}
  PROCESS {
    foreach ($ComputerObj in $Computer) {
      $TestPort = Test-NetConnection -ComputerName $ComputerObj.Name -Port $TcpPort -InformationLevel Quiet 2>$null 3>$null 4>$null 5>$null
      if ($TestPort -eq $true) {
        [PScustomobject]@{ComputerName=$ComputerObj.Name;TcpPort=$TcpPort;State="Open"}
      }
      else {
        [PScustomobject]@{ComputerName=$ComputerObj.Name;TcpPort=$TcpPort;State="Blocked"}
      }
    }
  }
  END{}
} 
