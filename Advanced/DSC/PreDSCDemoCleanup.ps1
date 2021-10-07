Invoke-Command -ComputerName 'LON-SVR1' -ScriptBlock {
  $content = @"
    <html>
    <head>
    </head>
    <body>
      <h1 style="text-align:center">DSC web site demo<h1>
      <br>
      <p>This is the website that was build using the <strong>DSC</strong> config file</p>
    </body>
    </html>
"@
  New-Item -Path C:\SiteData -ItemType Directory -Force
  New-Item -Path C:\SiteData -Name 'default.htm' -ItemType File -Force -Value $content 
  Remove-WindowsFeature -Name 'Web-Server' -IncludeManagementTools -Restart
}