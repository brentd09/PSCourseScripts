$Excel = New-Object -ComObject Excel.Application

$NewWorkbook = $Excel.Workbooks.Add()
$Item = $Excel.Worksheets.Item(1)
$Item.Cells.Item(1,2) = 'Sales' 
foreach ($x in 2..15) {
  $Item.Cells.Item($x,2) = Get-Random -Maximum 160 -Minimum 10
}
$Excel.Charts.Add()
$Excel.Visible = $true