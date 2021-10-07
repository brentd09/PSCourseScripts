Invoke-Command -ComputerName LON-SVR1 -ScriptBlock {
  Remove-WindowsFeature -Name web-server -IncludeManagementTools -Restart
}
