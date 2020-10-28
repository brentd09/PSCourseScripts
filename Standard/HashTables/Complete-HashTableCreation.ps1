# Creating hash tables method 1
$HashTable1 = [ordered]@{}
$HashTable1.IPAddress = '192.168.1.100'
$HashTable1.SubnetMask = '255.255.255.0'
$HashTable1.DefaultGW = '192.168.1.1'

$HashTable1

# Creating hash tables method 2
$HashTable2 = [ordered]@{
  IPAddress = '192.168.2.100'
  SubnetMask = '255.255.255.0'
  DefaultGW = '192.168.2.1'
}

$HashTable2

# Creating hash tables method 3
$HashTable3 = [ordered]@{}
$HashTable3.Add('IPAddress','192.168.3.100')
$HashTable3.Add('SubnetMask','255.255.255.0')
$HashTable3.Add('DefaultGW','192.168.3.1')

$HashTable3

# Using HashTables to create Objects

$HashTable4 = @{
  Name = 'Harry'
  Department = 'Sales'
  DateStarted = [datetime]'4 Jan 1993'
}
$Employee = New-Object -TypeName psobject -Property $HashTable4
$Employee