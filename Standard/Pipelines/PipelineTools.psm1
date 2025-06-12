function Get-PipeLineParameter {
  <#
  .SYNOPSIS
    Lists the pipeline parmaters for agiven command 
  .DESCRIPTION
    This command will show all paramters that are able to accept pipeline input
    for a given command, it will show the ParameterName, whether it supports 
    ByValue and/or ByPropertyName and the Type of object it can accept
  .PARAMETER Cmdlet
    This the name of the Cmdlet that will have it's parameters inspected for
    the ability to accept pipeline input    
  .NOTES
    Created By: Brent Denny
    Created On: 11 Jun 2025
  .EXAMPLE
    Get-PipeLineParameter -Cmdlet Get-Process
    This will show the parameters that will accept pipeline input for the Get-Process command:

    ParameterSetName        ParameterName ByValue ByPropertyName ParameterType               
    ----------------        ------------- ------- -------------- -------------               
    Name                    Name            False           True System.String[]             
    Name                    ComputerName    False           True System.String[]             
    NameWithUserName        Name            False           True System.String[]             
    IdWithUserName          Id              False           True System.Int32[]              
    Id                      Id              False           True System.Int32[]              
    Id                      ComputerName    False           True System.String[]             
    InputObjectWithUserName InputObject      True          False System.Diagnostics.Process[]
    InputObject             InputObject      True          False System.Diagnostics.Process[]
    InputObject             ComputerName    False           True System.String[] 
  #>
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Cmdlet
  )
  $CommandInfo = Get-Command -Name $Cmdlet
  foreach ($ParamSet in $CommandInfo.ParameterSets) {
    $PipelineParams = $ParamSet.Parameters | 
     Where-Object {$_.valuefrompipeline -eq $true -or $_.valuefrompipelineByPropertyName -eq $true } 
    $ReturnPipelineDetails = $PipelineParams | 
     Select-Object -Property @{n='ParameterSetName';e={$ParamSet.Name}},
                             @{n='ParameterName';e={$_.Name}},
                             @{n='ByValue';e={$_.ValueFromPipeline}}, 
                             @{n='ByPropertyName';e={$_.ValueFromPipelineByPropertyName}}, 
                             ParameterType
    $ReturnPipelineDetails 
  }
}

