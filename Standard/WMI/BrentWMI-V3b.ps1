<#
.SYNOPSIS
  Finds current settings for WMI classes
.DESCRIPTION
  This is a GUI that mimics the WMI scriptomatic tools but shows the information 
  directly in the GUI 
.NOTES
  General notes
  Created By: Brent Denny
  Created on: 10-Jan-2019
#>
[CmdletBinding()]
Param()



# Added Alternating Row Colours
# Added Function for "non-String" translation because the listbox gets cranky.
# Added resize to Value column to suit content.
# Double click and CTRL + C will copy values to clipboard.
# Added remote functions for current logged in user
# ComboBoxClass now sorts alphabetically




Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


### Convert-TypesToString - Converts other obejct times to strings to display in the listbox. Default has not been used in order to catch new/different/unidentified file types.
Function Convert-TypesToString($Object){
    switch ($object.GetType())
    { 
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
        ciminstance { $ConvertedString = $Object } # Deal with this later
        default { Write-Host "$($Object) - $($Object.GetType())"; $ConvertedString = "UNHANDLED" }
    }
 return $ConvertedString
}

### Places the parsed text on the system clipboard.
Function Set-ClipBoard{
    Param([string[]]$aTxt)
    $text=$aTxt|Out-String
    [System.Windows.Forms.Clipboard]::SetText($text)
}

### Updates the Combo Box for when the Namespace/CIM connection changes.
Function Update-ComboBoxClass{
  $ComboBoxClass.DataSource = @('')
  $labelClassRefresh.ForeColor = '#d0021b'  
  $labelClassRefresh.Text = "Please Wait while class list refreshes" 
  $CurrentNameSpace = "root\"+$ComboBoxNameSpace.SelectedValue
  $ComboBoxClass.DataSource = ((Get-CimClass -Namespace $currentNameSpace -CimSession $cimSession | Where-Object {$_.CimClassName -notlike "__*"}).CimClassName) | Sort
  $labelClassRefresh.Text = ""
}

### Checks for open port and authentication before connecting to the CIM instance and sets up the GUI.
Function Connect-cimTarget{
    If($args[0] -eq $null){
        $global:cimTarget = 'localhost'
    }Else{
        $global:cimTarget = $args[0]
    }
    If((Test-NetConnection -Port 5985 -ComputerName $cimTarget -InformationLevel Quiet) -or (Test-NetConnection -Port 5986 -ComputerName $cimTarget -InformationLevel Quiet)){
        Write-host "WinRM is Open and Listening on $($cimTarget)"
            If($CIMSession){ 
                Remove-CimSession $CIMSession
            }
            $Global:CIMSession = New-CimSession -ComputerName $cimTarget
            $ListViewOutput.items.Clear()
            $NameSpaces = Get-CimInstance -namespace "root" -class "__Namespace" -CimSession $CIMSession | Sort-Object -Property name
            $ComboBoxNameSpace.DataSource = $NameSpaces.name
            $ComboBoxNameSpace.SelectedItem = "CIMV2"
            $labelActualTarget.Text = $cimTarget
        
    }Else{
        Write-Host "Unable to connect to port 5985 or 5986 on $($cimTarget)." -ForegroundColor Red
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
$labelActualTarget.location      = New-Object System.Drawing.Point(500,55)
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
  ### Added Check to prevent the CIM Class query from going ballistic as the gui loads.
  if ($SelectedValue -ne '' -and $labelClassRefresh.Text -eq '') {
    ### Had to expand properties to get a workable array of items.

    $ClassDetails = Get-CimInstance -Namespace $CurrentNameSpace -CimSession $cimSession -ClassName $SelectedValue -Property * | select -ExpandProperty CiminstanceProperties | Foreach {$_ | Select -Property Name,Value}

    #Clear the list view, and then add all the new items in. Use the Convert-TypesToString function to process non-strings.
    $ListViewOutput.items.Clear()
    $RowCounter = 0

    ForEach($ClassItem in $ClassDetails){
        $RowCounter++
        $ListViewItem = $null
        $ListViewItem = New-Object System.Windows.Forms.ListViewItem($ClassItem.Name)
        If($ClassItem.Value -ne $Null){
            $ListviewItem.SubItems.Add("$($ClassItem.Value.GetType())") | Out-Null
            $ListviewItem.SubItems.Add($(Convert-TypesToString($ClassItem.Value))) | Out-Null
        }
        If($RowCounter % 2 -eq 0){
            $ListViewItem.BackColor = '#F2F2F2'
        }
        $ListViewOutput.Items.Add($ListViewItem) | Out-Null
    }

    #Resize the columns if we have a successful set of items to display (avoids accidently squashing the columns)
    If($ClassDetails -ne $null){
        $ListViewOutput.AutoResizeColumns(2)
        If((($ListViewOutput.Columns[0..2].width) | Measure -Sum).Sum -lt 660){
            $ListViewOutput.Columns[2].Width = (660 - (($ListViewOutput.Columns[0..1].width) | Measure -Sum).Sum)
            
        }
    }
  }
})

$FormWMIExplorer.Add_Shown({
  Connect-cimTarget
})

$FormWMIExplorer.ShowDialog()