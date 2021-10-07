Configuration BuildIIS {
  Param ([string]$ComputerName = 'LON-SVR1')

  Node $ComputerName {
    WindowsFeature IIS {
      Name = 'Web-Server'
      Ensure = 'Present'
    }
  }
}

BuildIIS
Start-DscConfiguration -Path .\BuildIIS -Wait -Verbose -Force
