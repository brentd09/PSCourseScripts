$TypeAcceleratorKeys = ([PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get).keys 
$TypeAcceleratorNames = New-Object -TypeName psobject -Property @{TypeAccel = $TypeAcceleratorKeys} |  Sort-Object  -Property TypeAccel
$TypeAcceleratorNames.TypeAccel | Sort-Object 