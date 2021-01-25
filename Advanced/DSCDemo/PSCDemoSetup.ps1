$DSCDemoExists = Test-Path 'E:\DSCDemo' -PathType Container
$WebContentExists = Test-Path 'E:\WebContent' -PathType Container
if ($DSCDemoExists -eq $false) {New-Item -Name 'DSCDemo' -Path 'e:\' -ItemType Directory}
if ($WebContentExists -eq $false) {New-Item -Name 'WebContent' -Path 'e:\' -ItemType Directory}
$DSCDemoScript = @'
configuration InstallDSCWebServer {
  node lon-svr1 {
    WindowsFeature WebServer {
      Ensure = "Present"
      Name   = "web-server"
    }

    File WebContent {
      Ensure          = "Present"
      SourcePath      = "\\lon-dc1\WebContent"
      DestinationPath = "c:\inetpub\wwwroot"
      Type            = "File"
      DependsOn       = "[WindowsFeature]WebServer"
      Force           = $true
    }
  }
}

InstallDSCWebServer
Write-Host "Now run: Start-DSCConfiguration -Wait -Verbose -Force -Path E:\DSCDemo\InstallDSCWebServer"
'@

$WebContentFile = @'
<html>
  <head>
    <style>
      .center {text-align: center;}
      .bold {font-weight: bold;}
      body {background-color: lightblue;}
    </style>
  </head>
  <body>
    <h1 lcass="center">BRENTS WEBSITE</h1><br><br>
    <p class="bold">This web site is the result of a DSC configuration script that does the following:</p>
    <ul class="bold">
      <li>Installs the windows feature, web-server</li>
      <li>After the web server install succeeds</li>
      <li>Copies the web content to the c:\inetpub\wwwroot directory</li>
    </ul>
  </body>
</html>
'@

$DSCDemoScript  > E:\DSCDemo\DSCScript.ps1
$WebContentFile > E:\WebContent\index.html

New-SmbShare -Name 'WebContent' -Path 'E:\WebContent'
