Invoke-Command -ComputerName 'LON-SVR1' -ScriptBlock {
  Remove-WindowsFeature -Name 'Web-Server' -IncludeManagementTools -Restart
}