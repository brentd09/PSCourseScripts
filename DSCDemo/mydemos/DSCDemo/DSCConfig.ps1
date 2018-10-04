Configuration WebIISDeploy {

  Import-Module xSmbShare

  Node 'LON-SVR1' {
    WindowsFeature WebServer {
      Ensure = 'Present'
      Name = 'Web-Server'
    } # Windows Feature

    File WebContent {
      Ensure = 'Present'
      SourcePath = '\\LON-DC1\webdemo\'
      DestinationPath = 'c:\Inetpub\wwwroot\'
      DependsOn = '[WindowsFeature]WebServer'
      Force = $true
      Recurse = $true
    } # File
  } # Node

  #Node 'LON-DC1' {
  #  File WebShare
  #}
} # Configuration

