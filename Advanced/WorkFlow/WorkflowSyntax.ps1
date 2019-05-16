[CmdletBinding()]
Param(
  [string[]]$ComputerName = @('LON-CL1','LON-DC1','LON-SVR1')
)

Workflow Get-ComputerServices {
  param (
    [string[]]$WorkFlowComputers
  )
  foreach -parallel ($Computer in $WorkFlowComputers) {
    InlineScript { get-service -name Bits -ComputerName $Using:Computer}
  }  
}
  
$ComputerServices = Get-ComputerServices -WorkFlowComputers $ComputerName
$ComputerServices