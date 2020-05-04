# this module cotains the following functions
# ConvertTo-LatLngCoords
# Get-NewRandomADUsers
# Get-Weather

function ConvertTo-LatLngCoords {
  <#
  .Synopsis
     This script takes a city/keyword name and returns the Long and Lat Coordinates
  .DESCRIPTION
     This script utilises one of the APIs that have been created by MapQuest
     to convert city names into coordinates. It produces a custom object
     output that contains the city name, Longatude and Latitude.
     If there is more than one city in the database the script will show 
     all known cities and their details.
  
     Latitude and Longitude Coordinate Accuracy
     Decimal Places   Example          Error Tollerence
     --------------   -------          ----------------
     0                1                111  km
     1                0.1              11.1 km
     2                0.01             1.11 km
     3                0.001            111  m
     4                0.0001           11.1 m
     5                0.00001          1.11 m
     6                0.000001         11.1 cm
     7                0.0000001        1.11 cm
     8                0.00000001       1.11 mm
  .EXAMPLE
     ConvertTo-LatLngCoords -Keyword Sydney -APIKey 123456787
     This will look for locations that have Sydney in its name. The script will 
     then return an object showing: Long,Lat,City,Class and Type place found.
  .PARAMETER Keyword
     Choose any major or semi-major city in the world to be converted into 
     Coordicates. You can give as much detail as you wish, just seperate the
     street, city, state, country by commas.
  .NOTES
     General notes
     Creation: Brent Denny 11 Oct 2017
     Modified: Brent Denny  8 Mar 2019
   .ROLE
     The role this cmdlet is to show how APIs work and how PowerShell
     can use them.
  #>
  [CmdletBinding()]
  Param(
    [parameter(Mandatory=$true)]
    [string[]]$Keyword,
    [string[]]$APIKey = ((New-Object System.Management.Automation.PSCredential ('name',(Read-Host -Prompt "Enter API Key" -AsSecureString ))).GetNetworkCredential().password)

  )
  $resultAPI = Invoke-RestMethod -Method Get -Uri "http://open.mapquestapi.com/nominatim/v1/search.php?key=$APIKey&format=json&q=$Keyword" -UseBasicParsing
  $locations = $resultAPI 
  foreach ($location in $locations) {  # Just in case there are multiple cities with same name
    $outputProp = [ordered]@{
      Lat = ('{0:N6}' -f $Location.lat) -as [double]
      Lng = ('{0:N6}' -f $location.lon) -as [double]
      City = $location.Display_Name
      Class = $location.Class
      Type = $location.Type
    } # END Hashtable
    New-Object -TypeName psobject -Property $outputProp
  } #END Foreach
} #END Function

function Get-NewRandomADUsers {
  [CmdletBinding()]
  Param (
    [string]$APIKey = ((New-Object System.Management.Automation.PSCredential ('name',(Read-Host -Prompt "Enter API Key" -AsSecureString ))).GetNetworkCredential().password)
  )
  $NewUsersCsv = Invoke-RestMethod -Method Get -Uri "https://my.api.mockaroo.com/random_ad_users.json?key=$APIKey" -UseBasicParsing
  $NewUsers = $NewUsersCsv | ConvertFrom-Csv
  $NewUsers
}

function Get-Weather {
  <#
  .SYNOPSIS
    Gets the weather for a city
  .DESCRIPTION
    This command gets the weather details for a city using an API from
    openweathermap.org 
  .EXAMPLE
    Get-Weather -City 'Melbourne,AU' -Key 2131231adef31112
    This will send the city and the key as values to the openweathermap
    API and will retrieve the weather information. The temperatures are
    in Kelvin by default from the API and so this scripts converts these
    into Celsius.
    The API returns the following:
    Parameters:
      coord
        coord.lon City geo location, longitude
        coord.lat City geo location, latitude
      weather (more info Weather condition codes)
        weather.id Weather condition id
        weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
        weather.description Weather condition within the group. You can get the output in your language. Learn more
        weather.icon Weather icon id
      base Internal parameter
      main
        main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        main.feels_like Temperature. This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
        main.humidity Humidity, %
        main.temp_min Minimum temperature at the moment. This is minimal currently observed temperature (within large megalopolises and urban areas). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        main.temp_max Maximum temperature at the moment. This is maximal currently observed temperature (within large megalopolises and urban areas). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        main.sea_level Atmospheric pressure on the sea level, hPa
        main.grnd_level Atmospheric pressure on the ground level, hPa
      wind
        wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
        wind.deg Wind direction, degrees (meteorological)
      clouds
        clouds.all Cloudiness, %
      rain
        rain.1h Rain volume for the last 1 hour, mm
        rain.3h Rain volume for the last 3 hours, mm
      snow
        snow.1h Snow volume for the last 1 hour, mm
        snow.3h Snow volume for the last 3 hours, mm
      dt Time of data calculation, unix, UTC
      sys
        sys.type Internal parameter
        sys.id Internal parameter
        sys.message Internal parameter
        sys.country Country code (GB, JP etc.)
        sys.sunrise Sunrise time, unix, UTC
        sys.sunset Sunset time, unix, UTC
      timezone Shift in seconds from UTC
      id City ID
      name City name
      cod Internal parameter
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
    [string]$City = 'Brisbane, AU',
    [string]$Key = ((New-Object System.Management.Automation.PSCredential ('DummyName',(Read-Host -Prompt "Enter API Key" -AsSecureString ))).GetNetworkCredential().password)
  )
  # Sunrise and sunset employ a conversion technique to convert the UNIX UTC time code to PS DateTime obj 
  $URI = 'http://api.openweathermap.org/data/2.5/weather?q='+$City+'&appid='+$Key
  Invoke-RestMethod -Method Get -Uri $URI -UseBasicParsing |
  Select-Object -ExcludeProperty main -Property @{n='City';e={$_.Name}},    
    @{n='CountryCode';e={$_.sys.Country}},
    @{n='Longatude';e={$_.coord.Lon}},
    @{n='Latitude';e={$_.coord.Lat}},
    @{n='Sunrise';e={(((Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($_.sys.Sunrise))).AddHours($_.TimeZone/60/60)).ToShortTimeString()}},
    @{n='Sunset';e={(((Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($_.sys.Sunset))).AddHours($_.TimeZone/60/60)).ToShortTimeString()}},
    @{n='WindDirection';e={$_.wind.Deg}},
    @{n='WindSpeed';e={$_.wind.speed}},
    @{n='TempCurrent';e={$_.main.temp - 273.15}},
    @{n='TempFeelsLike';e={$_.main.feels_like - 273.15}},
    @{n='Pressure';e={$_.main.Pressure}},
    @{n='Humidity';e={$_.main.humidity}}
}