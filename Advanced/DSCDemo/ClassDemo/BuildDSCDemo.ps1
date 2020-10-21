function Build-ClassDSCDemo {
  $WebSite = '<html><head><style>h1, h2 {text-align:center}</style></head><body><br><h1>Brents website</h1><br><h2>This was constructed by PowerShell DSC</h2></body></html>'
  
  Write-Host 'Saving the website to a share on LON-DC1'

  Invoke-Command -ComputerName 'lon-dc1' -ScriptBlock {
    New-Item -Path c:\ -Name WebShare -ItemType Directory -Force -ErrorAction SilentlyContinue
    $Using:WebSite | Out-File 'C:WebShare\index.html' -Force -ErrorAction SilentlyContinue
    New-SmbShare -Path 'C:\WebShare' -Name 'WebShare' -ErrorAction SilentlyContinue
  }
  
  Start-Sleep -Seconds 1
  Write-host 'DSC will now create the web server and site on LON-SVR1'

  Configuration BuildWebSite {
    Node ('lon-svr1') {
      WindowsFeature webserver {
        Ensure = 'Present'
        Name = 'web-server'
      }
  
      File webdata {
        Ensure = 'Present'
        SourcePath = '\\lon-dc1\WebShare\index.html'
        DestinationPath = 'C:\inetpub\wwwroot'
        Type = 'File'
        DependsOn = '[WindowsFeature]webserver'
        Force = $true
      }
    }
  }
  BuildWebSite
  Start-DSCConfiguration -Wait -Force -Verbose -Path .\BuildWebSite
}
Build-ClassDSCDemo
