### HTML REPORT TOOLS MODULE ###
function Get-CSS {
$CSS = @'
  <style>
  h1 {
    font-size: 50px;
    text-align: center;
  }
  h2 {
    font-size: 25px;
    text-align: center;
    color: DarkGreen;
  }
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
  return $CSS
}

function Convert-ServiceToHtml {
  return (
    Get-Service | 
    Select-Object -Property Status,StartType,Name | 
    ConvertTo-Html -Fragment –PreContent "<h2>Services</h2>" | 
    Out-String
  )
} 

function Convert-ProcessToHtml {
  return (
    Get-Process | 
    Select-Object -Property Name,Id,VirtualMemorySize | 
    ConvertTo-Html -Fragment –PreContent "<h2>Processes</h2>" | 
    Out-String
  )
}

function Merge-HtmlFragments {
  Param (
    $SvcFrag,
    $PrcFrag,
    $CSSBlock
  )
  return (ConvertTo-Html –Body "<h1>Service and Process Report</h1>",$SvcFrag,$PrcFrag -Head $CSSBlock) 

}

function Save-Html {
  Param (
    $HtmlDoc,
    $Path = "$home\Downloads\demo\report.html"
  )
  $HtmlDoc | Out-File $Path
  $objProp = @{Path = $Path}
  New-Object -TypeName psobject -Property $objProp
}

