# Sample object to serialize
$object = [PSCustomObject]@{
    Name = "John Doe"
    Age  = 30
    Email = "john.doe@example.com"
}

# Use PSSerializer to convert the object to CLI XML format
$cliXmlString = [System.Management.Automation.PSSerializer]::Serialize($object)

# Output the serialized XML string
$cliXmlString

# To deserialize the XML string back to a PowerShell object
[System.Management.Automation.PSSerializer]::Deserialize($cliXmlString)
