<# 
.NAME
    WordFile
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,400)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "open Doc file"
$Button1.width                   = 191
$Button1.height                  = 127
$Button1.location                = New-Object System.Drawing.Point(76,179)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($Button1))

$Button1.Add_Click({ [System.Diagnostics.Process]::Start("C:\Users\Brent.Denny\Documents\PSDemo\RayTest.docx") })

#region Logic 
function code { }

#endregion

[void]$Form.ShowDialog()