function Get-PSDefaultOutputFormat {
  <#
  .SYNOPSIS
    This shows the default screen output from PS cmdlets
  .DESCRIPTION
    PowerShell does not always show the entire set of properties by default on the screen.
    The formatting structures to change the output is found in ps1xml files in the PowerShell
    home directory.
    This script tries to identify object types and their default screen output formats
  .EXAMPLE
    Get-PSDefaultOutputFormat
    This will show the .Net object formats contained within the 
    C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml file.
  .PARAMETER PathToPs1xmlFile
    This parameter allows you to choose which ps1xml file you wish to inspect it will use
    C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml by default. 
  .NOTES
    General notes
      Created by:    Brent Denny
      Created on:    15 Sep 2021
      Last Modified: 15 Sep 2021
    Change Log:
    150921-completed initial build of script  
  #>
  Param (
    [string]$PathToPs1xmlFile = 'C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml'
  )
  [xml]$Formater = Get-Content -Path $PathToPs1xmlFile
  $Formater.Configuration.ViewDefinitions.View |  
    Select-Object @{n='TypeName';e={$_.ViewSelectedBy.TypeName}},
                  @{n='ColumnWidths';e={$_.TableControl.TableHeaders.TableColumnHeader.Width}},
                  @{n='Properties';e={$_.TableControl.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem.PropertyName}} 
} 
