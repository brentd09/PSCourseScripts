# Simple OK dialog
[System.Windows.MessageBox]::Show('Press Ok to Continue','Message from PowerShell','OK')

# Convert C# code to Powershell
<#      
  // Configure open file dialog box - C# Code
  var dialog = new Microsoft.Win32.OpenFileDialog();
  dialog.FileName = "*"; // Default file name
  dialog.DefaultExt = ".txt"; // Default file extension
  dialog.Filter = "Text documents (.txt)|*.txt"; // Filter files by extension
  
  // Show open file dialog box
  bool? result = dialog.ShowDialog();
  
  // Process open file dialog box results
  if (result == true)
  {
      // Open document
      string filename = dialog.FileName;
  }
#>

$Dialog = [Microsoft.Win32.OpenFileDialog]::new()
$Dialog.FileName = "*"
$Dialog.DefaultExt = ".txt"
$Dialog.Filter = "Text documents (*.txt)|*.txt"
$Result = $Dialog.ShowDialog()
if ($Result) {Write-Host -ForegroundColor Cyan $Dialog.FileName}