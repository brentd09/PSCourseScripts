#REQUIRES -modules HTML_REPORT
### CONTROLLER SCRIPT ###

$CSS = Get-CSS
$Svc = Convert-ServiceToHtml
$Prc = Convert-ProcessToHtml
$Html = Merge-HtmlFragments -SvcFrag $Svc -PrcFrag $Prc -CSSBlock $CSS
Save-Html -HtmlDoc $html