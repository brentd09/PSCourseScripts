$CSS = @'
<style>
table {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #ddd;
    padding: 8px;
}

tr:nth-child(even){background-color: #f2f2f2;}

tr:hover {background-color: #ddd;}

th {
    padding-top: 12px;
    padding-bottom: 12px;
    text-align: left;
    background-color: #4CAF50;
    color: white;
}
</style>
'@
$SvcFrag = Get-Service | Select-Object -Property Status,StartType,Name | ConvertTo-Html -Fragment –PreContent "<h2>Services</h2>" | Out-String
$PrcFrag = Get-Process | Select-Object -Property Name,Id,VirtualMemorySize | ConvertTo-Html -Fragment –PreContent "<h2>Processes</h2>" | Out-String
ConvertTo-Html –Body "<h1>Report</h1>",$SvcFrag,$PrcFrag -Head $CSS | Out-File $home\Documents\report.html

