$json = @'
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

$PSArray = $json | ConvertFrom-Json
$PSArray.employees += ($PSArray.employees | Select-Object @{n='Email';e={($_.firstName).tolower()+'.'+($_.lastName).tolower()+'@adatum.com'}})
$PSArray