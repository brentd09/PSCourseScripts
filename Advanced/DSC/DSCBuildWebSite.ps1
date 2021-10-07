Configuration BuildIIS {
  Param ([string]$ComputerName = 'LON-SVR1')

  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

  Node $ComputerName {
    WindowsFeature IIS {
      Name = 'Web-Server'
      Ensure = 'Present'
    }

    File WebSite {
      DependsOn = '[WindowsFeature]IIS'
      DestinationPath = 'c:\inetpub\wwwroot'
      SourcePath = 'C:\SiteData\default.htm'
      Type = 'File'
    }
  }
}

BuildIIS
Start-DscConfiguration -Path .\BuildIIS -Wait -Verbose -Force
