#Different ways to use Format-Table to control column width
 
Get-NetFirewallRule | 
  Select-Object -First 10 | 
  Format-Table -Property @{e='name';width=25}, @{e='DisplayName';width=30}

Get-NetFirewallRule | 
  Select-Object -First 10 | 
  Format-Table -Property @{n='NewName';e={$_.name};width=25}, @{n='NewDisplayName';e={$_.DisplayName};width=30}
