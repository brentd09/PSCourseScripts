Configuration WebIISDeploy {

  Node 'LON-SVR1' {
    WindowsFeature WebServer {
      Ensure = 'Present'
      Name = 'Web-Server'
    } # Windows Feature

    File WebContent {
      Ensure = 'Present'
      SourcePath = '\\lon-cl1\webdemo\'
      DestinationPath = 'c:\Inetpub\wwwroot\'
      DependsOn = '[WindowsFeature]WebServer'
      Force = $true
      Recurse = $true
    } # File
  } # Node
} # Configuration

