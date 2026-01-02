# Create an Excel application instance
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $true
$excel.DisplayAlerts = $false

# Add a new workbook
$workbook = $excel.Workbooks.Add()

# Add data to the first worksheet
$sheet1 = $workbook.Worksheets.Item(1)
$sheet1.Name = "Data"

# Sample data
$data = @(
    @{ Name = 'Product A'; Sales = 150 },
    @{ Name = 'Product B'; Sales = 200 },
    @{ Name = 'Product C'; Sales = 250 }
)

# Write headers
$sheet1.Cells.Item(1, 1) = "Name"
$sheet1.Cells.Item(1, 2) = "Sales"

# Write data
$row = 2
foreach ($item in $data) {
    $sheet1.Cells.Item($row, 1) = $item.Name
    $sheet1.Cells.Item($row, 2) = $item.Sales
    $row++
}

# Add a new worksheet for the chart
$sheet2 = $workbook.Worksheets.Add()
$sheet2.Name = "Chart"

# Create a chart
$chartObjects = $sheet2.ChartObjects()
$chartObject = $chartObjects.Add(10, 10, 300, 200) # (left, top, width, height)
$chart = $chartObject.Chart

# Set the chart range
$range = $sheet1.Range("A1:B$row") # Adjust to include all data
$chart.SetSourceData($range)

# Set chart type
$chart.ChartType = [Microsoft.Office.Interop.Excel.XlChartType]::xlColumnClustered

# Save and close Excel workbook
$excel.DisplayAlerts = $true
$workbook.SaveAs('C:\path\to\your\info.xlsx')
$excel.Quit()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($chart) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet1) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet2) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

# Garbage collection
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
