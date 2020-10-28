<#
.SYNOPSIS
  Splatting 
.DESCRIPTION
  Splatting is a way of passing multiple parameter values to a function by
  wrapping them into a hastable and then passing the hashtable to the function
  with the use of the @ symbol instead of the $ sign on the hash table variable
  for example: Write-Hello @SplatInfo, where $SplatInfo is a hastable object
.NOTES
  General notes
    Created By:  Brent Denny
    Created On:  28 Oct 2020
#>
function Write-Hello {
  Param (
    [string]$Name,
    [int]$Age,
    [string]$Country,
    [string]$State
  )
  $Message = "Hello {0}, I see that you are {1} years old and you live in {2} in the state of {3}" -f $Name,$Age,$Country,$State
  Write-Host $Message
}

$SplatPersonInfo = @{
  Name = 'Harry'
  Age = 23
}

$SplatLocationInfo = @{
  Country = 'Australia'
  State = 'QLD'
}

# Splatting can be done with one or more hash tables 
Write-Hello @SplatPersonInfo @SplatLocationInfo

# And can be used with traditional parameters
Write-Hello @SplatPersonInfo -Country NewZealand -State Auckland

# However the following would fail because age is specified twice 
# -age and in the @SplatPersonInfo hash table

# Write-Hello -age 100 @SplatPersonInfo -Country NewZealand -State Auckland 