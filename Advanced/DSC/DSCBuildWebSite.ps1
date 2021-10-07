Configuration BuildIIS {
  Param ([string]$ComputerName = 'LON-SVR1')

  Node $ComputerName {
    WindowsFeature IIS {
      Name = 'Web-Server'
      Ensure = 'Present'
    }

    WindowsFeature RSAT_IIS {
      Name = 'Web-Mgmt-Console'
      Ensure = 'Present'
      DependsOn = 'IIS'
    }
  }
}

BuildIIS 