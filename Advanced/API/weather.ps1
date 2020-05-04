function Get-Weather {
  <#
  .SYNOPSIS
    Gets the weather for a city
  .DESCRIPTION
    This command gets the weather details for a city using an API from
    openweathermap.org 
  .EXAMPLE
    Get-Weather -City 'Melbourne' -Key 2131231adef31112
    This will send the city and the key as values to the openweathermap
    API and will retrieve the weather information. The temperatures are
    in Kelvin by default from the API and so this scripts converts these
    into Celsius.
  .PARAMETER City
    This is the city that weather infomation should be retrieved for
  .PARAMETER Key
    This is the API key to access the API, you can freely register 
    at openweathermap.org for a free API key
  .NOTES
    General notes
  #>
  [cmdletbinding()]
  Param (
    [string]$City = 'Brisbane',
    [Parameter(Mandatory=$true)]
    [string]$Key 
  )
  
  $URI = 'http://api.openweathermap.org/data/2.5/weather?q='+$City+'&appid='+$Key
  Invoke-RestMethod -Method Get -Uri $URI -UseBasicParsing |
  Select-Object -ExcludeProperty main -Property *,
                                                @{n='CurrentTemp';e={$_.main.temp - 273.15}},
                                                @{n='FeelsLike';e={$_.main.feels_like - 273.15}},
                                                @{n='MaxTemp';e={$_.main.temp_max - 273.15}},
                                                @{n='MinTemp';e={$_.main.temp_min - 273.15}},
                                                @{n='Pressure';e={$_.main.Pressure}},
                                                @{n='Humidity';e={$_.main.humidity}}
}