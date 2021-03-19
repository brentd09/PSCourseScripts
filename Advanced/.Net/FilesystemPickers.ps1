$folderpicker = [System.Windows.Forms.FolderBrowserDialog]::new()
$folderpicker.RootFolder = 'C:\'
$folderpicker.ShowDialog()
$folderpicker.SelectedPath



$filePicker =  [System.Windows.Forms.OpenFileDialog]::new()
$filePicker.InitialDirectory = 'C:\'
$filePicker.Multiselect = $true
$filePicker.Title = 'Choose one or more files'
$filePicker.ShowDialog() |Out-Null
$filePicker.FileNames