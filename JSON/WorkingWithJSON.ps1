$JSONString = @'
{"employees":[
    { "firstName":"John",
      "lastName":"Doe" 
    },
    { "firstName":"Anna",
      "lastName":"Smith" 
    },
    { "firstName":"Peter", 
      "lastName":"Jones" 
    }
]}
'@

# Adding Attributes to JSON
###########################

# This code converts the JSON into an array of PowerShell Objects
# we then add a calcualted property Email
# this is then injected back into the object array
# lastly the array is converted back to JSON
Write-host $JSONString
Read-Host -Prompt "The old JSON string will be modified to include an email address, Press ENTER to see the change"
$CompanyObj = $JSONString | ConvertFrom-Json
$EmployeesAndEmail = $CompanyObj.employees | Select-Object *,@{n='Email';e={($_.firstName).tolower()+'.'+($_.lastName).tolower()+'@adatum.com'}}
$CompanyObj.employees = $EmployeesAndEmail
$CompanyObj | ConvertTo-Json

# Adding a new node to JSON
###########################

# This part of the code creates a new employee object and adds it to
# the existing users

Write-Host "Now that email has been added we will add another employee"
Read-Host -Prompt "Press ENTER to see the new JSON data"
$NewNodeProps = @{
  fistName = 'Gretta'
  LastName = 'Garbo'
  Email = 'gretta.garbo@adatum.com'
}
$NewNodeObj = New-Object -TypeName psobject -Property $NewNodeProps
$CompanyObj.employees += $NewNodeObj
$CompanyObj | ConvertTo-Json