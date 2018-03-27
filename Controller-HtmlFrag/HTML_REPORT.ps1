#REQUIRES -modules HTML_REPORT
### CONTROLLER SCRIPT ###
do {
  $BadChoice = $false
  Clear-Host
  Write-Host -BackgroundColor Yellow -ForegroundColor Black "TASK MENU"
  Write-Host -ForegroundColor Yellow -NoNewline " 1. "
  Write-Host "Create a web report"
  Write-Host -ForegroundColor Yellow -NoNewline " 2. "
  Write-Host "QUIT"
  Write-Host
  $Selection = Read-Host -Prompt "Enter a menu selection"
  switch ($Selection)
  {
      1 {
          $CSS = Get-CSS
          $Svc = Convert-ServiceToHtml
          $Prc = Convert-ProcessToHtml
          $Html = Merge-HtmlFragments -SvcFrag $Svc -PrcFrag $Prc -CSSBlock $CSS
          $SaveResult = Save-Html -HtmlDoc $html
          Write-Host "The report was written to $SaveResult.path"
          Read-Host 
      }
      2 { 
          "BYE"
      }
      Default {
        "Wrong selection try again"
        $BadChoice = $true
        Start-Sleep -Seconds 3
      }
  }
} while ($BadChoice -eq $true -or $Selection -eq 1)

