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

# This code converts the JSON into an array of PowerShell Objects
# we then add a calcualted property Email
# this is then injected back into the object array
# lastly the array is converted back to JSON
$CompanyObj = $JSONString | ConvertFrom-Json
$EmployeesAndEmail = $CompanyObj.employees | Select-Object *,@{n='Email';e={($_.firstName).tolower()+'.'+($_.lastName).tolower()+'@adatum.com'}}
$CompanyObj.employees = $EmployeesAndEmail
$CompanyObj | ConvertTo-Json