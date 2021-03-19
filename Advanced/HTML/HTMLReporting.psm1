function New-HTMLReport {
  [cmdletbinding()]
  Param (
    [Parameter(ValueFromPipeline)]
    [psobject]$Object,
    [string]$ReportTitle,
    [string]$Footer
  )
  Begin {
    $Count = 0
    $CSVHeader  =''
    $CSVBody = @()
    $CSS = @'
    <style>
    #ReportTitle {
      font-family: Arial, Helvetica, sans-serif;
      text-align: center;
    } 

    table {
      font-family: Arial, Helvetica, sans-serif;
      border-collapse: collapse;
      width: 100%;
    }
    
    td,  th {
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
  }
  Process {
    if ($PSCmdlet.MyInvocation.ExpectingInput) { # True if the inforamtion has come through the pipeline
      if ($Count -eq 0) {$CSVHeader = ($Object | ConvertTo-Csv -NoTypeInformation | Select-Object -First 1 ) + "`n"}
      $CSVBody += ($Object | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1) + "`n"

    }
    else {
      if ($Count -eq 0) {$CSVHeader = ($Object | ConvertTo-Csv -NoTypeInformation  | Select-Object -First 1 ) + "`n"}
      $CSVBody = ($Object | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 ) -join "`n"

    }
    $Count++
  }
  End {$CSVHeader + $CSVBody | ConvertFrom-Csv | ConvertTo-Html -Head $CSS -PreContent "<h1 id=ReportTitle>$ReportTitle</h1>" -PostContent $Footer
  }
}
