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


# (Get-WmiObject -Class win32_bios ).properties | Select-Object -Property @{n='Info';e={$_.Name + " = " + $_.Value}}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


### Added Function to deal with "non Strings"
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
        ciminstance { $ConvertedString = $Object } # Deal with this later
        default { Write-Host "$($Object) - $($Object.GetType())"; $ConvertedString = "UNHANDLED" }
    }
 return $ConvertedString
}

#Changed Border style to not be expandable
$FormWMIExplorer                 = New-Object system.Windows.Forms.Form
$FormWMIExplorer.ClientSize      = '713,560'
$FormWMIExplorer.text            = "Brents WMI Explorer"
$FormWMIExplorer.TopMost         = $false
$FormWMIExplorer.FormBorderStyle = "FixedSingle"


$ComboBoxNameSpace                = New-Object system.Windows.Forms.ComboBox
$ComboBoxNameSpace.width          = 277
$ComboBoxNameSpace.height         = 30
$ComboBoxNameSpace.location       = New-Object System.Drawing.Point(14,30)

$ComboBoxClass                    = New-Object system.Windows.Forms.ComboBox
$ComboBoxClass.width              = 378
$ComboBoxClass.height             = 30
$ComboBoxClass.location           = New-Object System.Drawing.Point(312,30)

$labelNameSpace                  = New-Object system.Windows.Forms.Label
$labelNameSpace.text             = "Namespace"
$labelNameSpace.AutoSize         = $true
$labelNameSpace.width            = 25
$labelNameSpace.height           = 10
$labelNameSpace.location         = New-Object System.Drawing.Point(14,5)
$labelNameSpace.Font             = 'Microsoft Sans Serif,10'

$labelClass                      = New-Object system.Windows.Forms.Label
$labelClass.text                 = "Class"
$labelClass.AutoSize             = $true
$labelClass.width                = 25
$labelClass.height               = 10
$labelClass.location             = New-Object System.Drawing.Point(312,5)
$labelClass.Font                 = 'Microsoft Sans Serif,10'

$labelClassRefresh               = New-Object system.Windows.Forms.Label
$labelClassRefresh.AutoSize      = $true
$labelClassRefresh.width         = 25
$labelClassRefresh.height        = 10
$labelClassRefresh.location      = New-Object System.Drawing.Point(280,70)
$labelClassRefresh.Font          = 'Microsoft Sans Serif,10'

$ListViewOutput                  = New-Object system.Windows.Forms.ListView
$ListViewOutput.View             = 'Details'
$ListViewOutput.width            = 680
$ListViewOutput.height           = 420
$ListViewOutput.location         = New-Object System.Drawing.Point(14,100)
$ListViewOutput.FullRowSelect    = $true
$ListViewOutput.Columns.add("Name", -2) | Out-Null
$ListViewOutput.Columns.add("Type") | Out-Null
$ListViewOutput.Columns.add("Value") | Out-Null
$ListViewOutput.AutoResizeColumns(1)

$labelClassContents              = New-Object system.Windows.Forms.Label
$labelClassContents.text         = "Class Details"
$labelClassContents.AutoSize     = $true
$labelClassContents.width        = 25
$labelClassContents.height       = 10
$labelClassContents.location     = New-Object System.Drawing.Point(14,70)
$labelClassContents.Font         = 'Microsoft Sans Serif,10'

$FormWMIExplorer.controls.AddRange(@(
  $ComboBoxNameSpace,
  $ComboBoxClass,
  $labelNameSpace,
  $labelClass,
  $labelClassRefresh,
  $ListViewOutput,
  $labelClassContents
))

$ComboBoxNameSpace.Add_SelectedValueChanged({
  $ComboBoxClass.DataSource = @('')
  $labelClassRefresh.ForeColor = '#d0021b'  
  $labelClassRefresh.Text = "Please Wait while class list refreshes" 
  $CurrentNameSpace = "root\"+$ComboBoxNameSpace.SelectedValue
  #  Updated to CIM Class and sorted list of values
  $ComboBoxClass.DataSource = ((Get-CimClass -Namespace $currentNameSpace | Where-Object {$_.CimClassName -notlike "__*"}).CimClassName) | Sort
  $labelClassRefresh.Text = ""
})

$ComboBoxClass.Add_SelectedValueChanged({
  $SelectedValue = $ComboBoxClass.SelectedValue
  ### Added Check to prevent the CIM Class query from going ballistic as the gui loads.
  if ($SelectedValue -ne '' -and $labelClassRefresh.Text -eq '') {
    ### Had to expand properties to get a workable array of items.

    $ClassDetails = Get-CimInstance -Namespace $CurrentNameSpace -ClassName $SelectedValue -Property * | select -ExpandProperty CiminstanceProperties | Foreach {$_ | Select -Property Name,Value}

    #Clear the list view, and then add all the new items in. Use the Convert-TypesToString function to process non-strings.
    $ListViewOutput.items.Clear()

    ForEach($ClassItem in $ClassDetails){
        $ListViewItem = $null
        $ListViewItem = New-Object System.Windows.Forms.ListViewItem($ClassItem.Name)
        If($ClassItem.Value -ne $Null){
            $ListviewItem.SubItems.Add("$($ClassItem.Value.GetType())") | Out-Null
            $ListviewItem.SubItems.Add($(Convert-TypesToString($ClassItem.Value))) | Out-Null
        }
        $ListViewOutput.Items.Add($ListViewItem) | Out-Null
    }

    #Resize the columns if we have a successful set of items to display (avoids accidently squashing the columns)
    If($ClassDetails -ne $null){
        $ListViewOutput.AutoResizeColumns(2)
    }
  }
})

$FormWMIExplorer.Add_Shown({
  $NameSpaces = Get-CimInstance -namespace "root" -class "__Namespace" | Sort-Object -Property name
  $ComboBoxNameSpace.DataSource = $NameSpaces.name
  $ComboBoxNameSpace.SelectedItem = "CIMV2"
})

$FormWMIExplorer.ShowDialog()