<#
  Functions in this module
  Get-WmiNamespace
  Invoke-WMIExplorer
  Get-AllWmiClassNames
#>

function Get-WmiNamespace {
  <#
  .SYNOPSIS
    This will get a list of all namespaces that exist from a chosen root namespace
  .DESCRIPTION
    When run with no parameters this command will default to root as the main namespace and 
    then list all of the namespaces it can find. It also has a parameter that allows you to
    locate all of the classes within the namespaces that were found.
  .PARAMETER RootNamespace
    This parameter allows you to override the default root namespace as the starting point for 
    the namespace and class search 
  .PARAMETER Classes
    This parameter turns on feature that searches for classes within the namespaces found
  .EXAMPLE
    Get-WmiNamespace 
    This will just show a list of namespaces located from the root
  .EXAMPLE
    Get-WmiNamespace -RootNamespace root\CIMV2
    This will show all namespaces that exist under the root\CIMV2 namespace
  .EXAMPLE
    Get-WmiNamespace -RootNamespace root\CIMV2 -Classes
    This will show all of the class names that are found in all of the namespaces under the
    root\CIMV2 namespace.
  .NOTES
    General notes
      Created By:  Brent Denny
      Created On:  23 Jan 2020
      Modified On: 26 Jan 2020 
  #>
  [CmdletBinding()]    
  Param (
    [string]$RootNamespace='root',
    [switch]$Classes
  )
  $RootNamespace = $RootNamespace.ToUpper()
  try {
    $Namespaces =  Get-WmiObject -Namespace $RootNamespace -Class __NAMESPACE  -ErrorAction Stop | ForEach-Object {
      Write-Progress -Activity 'Getting all of the name spaces'
      ($ns = '{0}\{1}' -f $_.__NAMESPACE,$_.Name)
      Get-WmiNamespace $ns
    }
  }
  Catch {
    Write-Warning "There was a issue communicating with the namespace "
    break
  }  
  if ($Classes -eq $false) {
    $RootNamespace
    $Namespaces
  }
  else {
    $Counter = 0
    foreach ($Namespace in $Namespaces) {
      $Counter++
      if ($Counter -eq 1) {Get-WmiObject -Namespace $RootNamespace -list | Sort-Object -Property Name -Descending}
      else {Get-WmiObject -Namespace $Namespace -list | Sort-Object -Property Name -Descending}
    }
  }
}

function Invoke-WMIExplorer {
  <#
  .SYNOPSIS
    Finds current settings for WMI classes
  .DESCRIPTION
    This is a GUI that mimics the WMI scriptomatic tools but shows the information 
    directly in the GUI 
  .NOTES
    General notes
    Created By:  Brent Denny
    Created on:  10-Jan-2019
    Last Update: 23 Jan 2020
  #>
  [CmdletBinding()]
  Param()
  Add-Type -AssemblyName System.Windows.Forms
  [System.Windows.Forms.Application]::EnableVisualStyles()
  Function Convert-TypesToString($Object) {
    switch ($object.GetType()) { 
      string { $ConvertedString = $Object }
      string[] { $ConvertedString = [string]::Concat($Object)}
      uint16 { $ConvertedString = $Object }
      uint16[] { $ConvertedString = [System.Text.Encoding]::Default.GetString($Object)}
      uint32 { $ConvertedString = $Object }
      uint64{ $ConvertedString = $Object }
      int16 { $ConvertedString = $Object }
      long { $ConvertedString = $Object }
      bool { If($object){$ConvertedString = "True"}Else{$ConvertedString = "False"}}
      datetime {$ConvertedString = (Get-Date $object).ToString()}
      byte { $ConvertedString = $Object }
      double { $ConvertedString = $Object }
      ciminstance { $ConvertedString = $Object.ToString() }
      default { Write-Host "$($Object) - $($Object.GetType())"; $ConvertedString = "UNHANDLED" }
    }
   return $ConvertedString
  }
  
  Function Set-ClipBoard{
    Param([string[]]$aTxt)
    $text=$aTxt|Out-String
    [System.Windows.Forms.Clipboard]::SetText($text)
  }
  
  Function Update-ComboBoxClass{
    $ComboBoxClass.DataSource = @('')
    $labelClassRefresh.ForeColor = '#d0021b'  
    $labelClassRefresh.Text = "Please Wait while class list refreshes" 
    $CurrentNameSpace = "root\"+$ComboBoxNameSpace.SelectedValue
    $ComboBoxClass.DataSource = ((Get-CimClass -Namespace $currentNameSpace -CimSession $cimSession | Where-Object {$_.CimClassName -notlike "__*"}).CimClassName) | Sort
    $labelClassRefresh.Text = ""
  }
  
  Function Connect-cimTarget{
    If ($args[0] -eq '') {
      $global:cimTarget = 'localhost'
    }
    Else {
      $global:cimTarget = $args[0]
    }
    If((Test-NetConnection -Port 5985 -ComputerName $cimTarget -InformationLevel Quiet) -or (Test-NetConnection -Port 5986 -ComputerName $cimTarget -InformationLevel Quiet)){
      If($CIMSession){ 
        Remove-CimSession $CIMSession -ErrorAction SilentlyContinue
        $Global:CIMSession = $null
      }         
      try {
        $Global:CIMSession = New-CimSession -ComputerName $cimTarget -ErrorAction Stop
      }
      catch [Microsoft.Management.Infrastructure.CimException]{
        try{
          $Global:Credentials = Get-Credential -Message "Current Credentials have failed. Please enter a username and password for a user with appropriate access to WinRM."
          $Global:CIMSession = New-CimSession -ComputerName $cimTarget -Credential $Credentials -ErrorAction Stop
        }
        catch {
          $ButtonType = [System.Windows.MessageBoxButton]::Ok
          $MessageboxTitle = “Authentication has failed”
          $Messageboxbody = “Alternate credentials have failed. Please try again and confirm your credentials have appropriate access.”
          $MessageIcon = [System.Windows.MessageBoxImage]::Error
          [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon)
        }
      } 
      finally {
        If($CIMSession){
          $ListViewOutput.items.Clear()
          $labelActualTarget.ForeColor = "Green"
          $labelActualTarget.Text = "$($cimTarget) is connected"
          $NameSpaces = Get-CimInstance -namespace "root" -class "__Namespace" -CimSession $CIMSession -ErrorAction Stop| Sort-Object -Property name
          $ComboBoxNameSpace.DataSource = $NameSpaces.name
          $ComboBoxNameSpace.SelectedItem = "CIMV2"
        }else{
          $labelActualTarget.Text = "ERROR - No Connection"
          $labelActualTarget.ForeColor = "Red"
        }
      }
    }
    Else {
      $ButtonType = [System.Windows.MessageBoxButton]::Ok
      $MessageboxTitle = “WinRM is not listening on $($cimTarget)”
      $Messageboxbody = “WinRM is not listening on ports 5985 or 5986 on remote host $($cimTarget).”
      $MessageIcon = [System.Windows.MessageBoxImage]::Error
      [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon,0,0)
    }
  }
  
  
  $FormWMIExplorer                 = New-Object system.Windows.Forms.Form
  $FormWMIExplorer.ClientSize      = '713,600'
  $FormWMIExplorer.text            = "Brents WMI Explorer"
  $FormWMIExplorer.TopMost         = $false
  $FormWMIExplorer.FormBorderStyle = "FixedSingle"
  
  $labelNameSpace                  = New-Object system.Windows.Forms.Label
  $labelNameSpace.text             = "Namespace:"
  $labelNameSpace.AutoSize         = $true
  $labelNameSpace.width            = 25
  $labelNameSpace.height           = 10
  $labelNameSpace.location         = New-Object System.Drawing.Point(14,10)
  $labelNameSpace.Font             = 'Microsoft Sans Serif,10'
  
  $ComboBoxNameSpace               = New-Object system.Windows.Forms.ComboBox
  $ComboBoxNameSpace.width         = 277
  $ComboBoxNameSpace.height        = 30
  $ComboBoxNameSpace.location      = New-Object System.Drawing.Point(14,30)
  
  $labelTarget                     = New-Object system.Windows.Forms.Label
  $labelTarget.text                = "Target:"
  $labelTarget.AutoSize            = $true
  $labelTarget.width               = 25
  $labelTarget.height              = 10
  $labelTarget.location            = New-Object System.Drawing.Point(500,10)
  $labelTarget.Font                = 'Microsoft Sans Serif,10'
  
  $TextBoxTarget                   = New-Object system.Windows.Forms.TextBox
  $TextBoxTarget.width             = 150
  $TextBoxTarget.height            = 30
  $TextBoxTarget.location          = New-Object System.Drawing.Point(545,10)
  $TextBoxTarget.Text              = "localhost"
  
  $labelClass                      = New-Object system.Windows.Forms.Label
  $labelClass.text                 = "Class:"
  $labelClass.AutoSize             = $true
  $labelClass.width                = 25
  $labelClass.height               = 10
  $labelClass.location             = New-Object System.Drawing.Point(14,55)
  $labelClass.Font                 = 'Microsoft Sans Serif,10'
  
  $ComboBoxClass                   = New-Object system.Windows.Forms.ComboBox
  $ComboBoxClass.width             = 378
  $ComboBoxClass.height            = 30
  $ComboBoxClass.location          = New-Object System.Drawing.Point(14,80)
  
  $labelActualTarget               = New-Object system.Windows.Forms.Label
  $labelActualTarget.text          = "localhost"
  $labelActualTarget.AutoSize      = $true
  $labelActualTarget.width         = 25
  $labelActualTarget.height        = 10
  $labelActualTarget.location      = New-Object System.Drawing.Point(500,40)
  $labelActualTarget.Font          = 'Microsoft Sans Serif,10'
  
  
  $labelClassRefresh               = New-Object system.Windows.Forms.Label
  $labelClassRefresh.AutoSize      = $true
  $labelClassRefresh.width         = 25
  $labelClassRefresh.height        = 10
  $labelClassRefresh.location      = New-Object System.Drawing.Point(280,110)
  $labelClassRefresh.Font          = 'Microsoft Sans Serif,10'
  
  $ListViewOutput                  = New-Object system.Windows.Forms.ListView
  $ListViewOutput.View             = 'Details'
  $ListViewOutput.width            = 680
  $ListViewOutput.height           = 435
  $ListViewOutput.location         = New-Object System.Drawing.Point(14,140)
  $ListViewOutput.FullRowSelect    = $true
  $ListViewOutput.Columns.add("Name", -2) | Out-Null
  $ListViewOutput.Columns.add("Type") | Out-Null
  $ListViewOutput.Columns.add("Value") | Out-Null
  $ListViewOutput.BorderStyle      = 1
  $ListViewOutput.AutoResizeColumns(1)
  
  
  $labelClassContents              = New-Object system.Windows.Forms.Label
  $labelClassContents.text         = "Class Details"
  $labelClassContents.AutoSize     = $true
  $labelClassContents.width        = 25
  $labelClassContents.height       = 10
  $labelClassContents.location     = New-Object System.Drawing.Point(14,110)
  $labelClassContents.Font         = 'Microsoft Sans Serif,10'
  
  $FormWMIExplorer.controls.AddRange(@(
    $ComboBoxNameSpace,
    $ComboBoxClass,
    $labelNameSpace,
    $labelClass,
    $labelClassRefresh,
    $ListViewOutput,
    $labelClassContents,
    $TextBoxTarget,
    $labelTarget,
    $labelActualTarget
  ))
  
  
  
  ### Add options for copying values out for both double click and CTRL + C
  $ListViewOutput.Add_MouseDoubleClick({
    set-clipboard $ListViewOutput.SelectedItems.SubItems[2].Text
  })
  
  $ListViewOutput.Add_KeyDown([System.Windows.Forms.KeyEventHandler]{
    if($_.Control -and $_.KeyCode -eq 'C'){
      set-clipboard $ListViewOutput.SelectedItems.SubItems[2].Text
    }
  })
  
  $TextBoxTarget.Add_KeyDown([System.Windows.Forms.KeyEventHandler]{
    if($_.KeyCode -eq 'Enter'){
      Connect-cimTarget $TextBoxTarget.Text
    }
  })
  
  $ComboBoxNameSpace.Add_SelectedValueChanged({
    # Moved to function so this can be called again later if target changes.
    Update-ComboBoxClass
  })
  
  $ComboBoxClass.Add_SelectedValueChanged({
    $SelectedValue = $ComboBoxClass.SelectedValue
    ### Added Check to prevent the CIM Instance query from going ballistic as the gui loads.
    if ($SelectedValue -ne '' -and $labelClassRefresh.Text -eq '') {
      ### Had to expand properties to get a workable array of items.
      $ClassDetails = Get-CimInstance -Namespace $CurrentNameSpace -CimSession $cimSession -ClassName $SelectedValue -Property * | select -ExpandProperty CiminstanceProperties | Foreach {$_ | Select -Property Name,Value}
      $labelClassRefresh.Text = 'Loading... Please Wait (this could take a while)'
      #Clear the list view, and then add all the new items in. Use the Convert-TypesToString function to process non-strings.
      $ListViewOutput.items.Clear()
      $RowCounter = 0
  
      ForEach($ClassItem in $ClassDetails){
        $RowCounter++
        $ListViewItem = $null
        $ListViewItem = New-Object System.Windows.Forms.ListViewItem($ClassItem.Name)
        If($ClassItem.Value){
          $ListviewItem.SubItems.Add("$($ClassItem.Value.GetType())") | Out-Null
          $ListviewItem.SubItems.Add($(Convert-TypesToString($ClassItem.Value))) | Out-Null
        }
        If($RowCounter % 2 -eq 0){
          $ListViewItem.BackColor = '#F2F2F2'
        }
        $ListViewOutput.Items.Add($ListViewItem) | Out-Null
      }
  
      $labelClassRefresh.Text = ''
      #Resize the columns if we have a successful set of items to display (avoids accidently squashing the columns)
      If ($ClassDetails) {
        $ListViewOutput.AutoResizeColumns(2)
        If ((($ListViewOutput.Columns[0..2].width) | Measure -Sum).Sum -lt 660) {
          $ListViewOutput.Columns[2].Width = (660 - (($ListViewOutput.Columns[0..1].width) | Measure -Sum).Sum)  
        }
      }
    }
  })
  
  $FormWMIExplorer.Add_Shown({
    Connect-cimTarget
  })
  
  $FormWMIExplorer.ShowDialog()
}
  
function Get-AllWmiClassNames {
    <#
    .SYNOPSIS
      This will get a list of all classnames that exist is all namespaces under the chosen root namespace
    .DESCRIPTION
      This command collects all of the namespaces from chosen root and then foreach of them
      finds the classnames within each and displays both the classname information and
      the namespace it came from
    .PARAMETER StartingNameSpace
      This parameter allows you to override the default root namespace as the starting point for 
      the namespace and classname search 
    .EXAMPLE
      Get-Get-AllWmiClassNames 
      This will just show a list of namespaces located from the root
    .EXAMPLE
      Get-Get-AllWmiClassNames -StartingNameSpace root\CIMV2
      This will show all namespaces and classes that exist under the root\CIMV2 namespace
    .NOTES
      General notes
        Created By:  Brent Denny
        Created On:  18 Apr 2020
        Modified On: 20 Apr 2020 
    #>
  Param ($StartingNameSpace = 'root')
  $NameSpaces = Get-CimInstance -Namespace $StartingNameSpace -ClassName "__Namespace" | 
    Select-Object -Property *,@{n='FullNameSpacePath';e={$StartingNameSpace + '\' +$_.Name}}
  foreach ($NameSpace in $NameSpaces) {
    Get-CimClass -Namespace $NameSpace.FullNameSpacePath | Select-Object CimClassName,@{n='NameSpace';e={$NameSpace.FullNameSpacePath}}
  }
}