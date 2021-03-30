# Copied from https://marckean.com/2015/09/21/use-powershell-to-make-rest-api-calls-using-json-oauth/
####################################################################################################
# for other exaples try https://www.example-code.com/powershell/oauth2.asp
#############################################################



# Google Blogger necessities – Setup your app here https://console.developers.google.com/ along with OAuth credentials
$blogID = "This is the ID of your blog, a series of numbers found on the Blogger site"
$app_key = "This is your client ID from your Google app"
$app_secret = "This is your client secret from your Google app"
$redirect_uri = "https://domain.com" # Can be any HTTPS URL, URL has to be specified when adding the OAuth credentials to your app here https://console.developers.google.com/
 
# Twitter necessities – http://www.adamtheautomator.com/twitter-module-powershell/
$TwitterApiKey = 'n924hf924f92f0824f'
$TwitterApiSecret = 'ng3op8g39ghn39g4wn8gi3p'
$TwitterAccessToken = 'n938hgv0985jg0398g059jg03g950jg'
$TwitterAccessTokenSecret = 'jv30498g05jg498h3u04u533j9g05g839hg5893'
 
$TwitterMessage = "Songs played on the Australian Radio Network in the past hour: " # URL is automatically appended
 
<######################################################################################
 
### Start polling station websites for data on a loop
Then write hourly results to a new Google Blogger post and tweet the URL on Twitter
 
######################################################################################>
 
#region If no refresh token, get a Google refresh token now. Doing this early as human interaction may be required.
 
### If no refresh token – requires human interaction with IE
if(!($refreshToken)){
 
### Get Google API access – https://developers.google.com/identity/protocols/OAuth2WebServer#offline
$scope = "https://www.googleapis.com/auth/blogger"
$response_type = "code"
$approval_prompt = "force"
$access_type = "offline"
 
### Get the authorization code
$auth_string = "https://accounts.google.com/o/oauth2/auth?scope=$scope&response_type=$response_type&redirect_uri=$redirect_uri&client_id=$app_key&access_type=$access_type&approval_prompt=$approval_prompt"
 
$ie = New-Object –comObject InternetExplorer.Application
if($approval_prompt -eq "force"){$ie.visible = $true}
$ie.navigate($auth_string)
#Wait for user interaction in IE, manual approval
do{Start-Sleep 1}until($ie.LocationURL -match 'code=([^&]*)')
$null = $ie.LocationURL -match 'code=([^&]*)'
$authorizationCode = $matches[1]
$ie.Quit()
 
### exchange the authorization code for a refresh token and access token
$grantType = "authorization_code"
$requestUri = "https://accounts.google.com/o/oauth2/token"
$requestBody = "code=$authorizationCode&client_id=$app_key&client_secret=$app_secret&grant_type=$grantType&redirect_uri=$redirect_uri"
 
$response = Invoke-RestMethod –Method Post –Uri $requestUri –ContentType "application/x-www-form-urlencoded" –Body $requestBody
 
$refreshToken = $response.refresh_token
}
 
#endregion
 
#region Clear the variables and setup the variable arrays for the data to be captured to
 
$973fmresult = @()
 
#endregion
 
#region Capture app radio statons on a approx 1 min loop
 
while ($true){
$freshpopsonglist = @()
 
#region Capture data phase
cls
#973 FM – Brisbane
$matches = @()
Start-Sleep –Seconds 1
Write-Host –NoNewline "Now playing on 973 FM" –ForegroundColor Cyan;Write-Host " Brisbane" –ForegroundColor Yellow
$uri = (Invoke-WebRequest 'http://media.arn.com.au/xml/973_now.xml').content
Start-Sleep –Seconds 1
$null = $uri -match '<now_playing>(.|\n)*artist><!\[CDATA\[([^]]*)\]\]></artist(.|\n)*</now_playing>';$artist = $matches[2]
$null = $uri -match '<now_playing>(.|\n)*title\sgeneric="False"><!\[CDATA\[([^]]*)\]\]></title(.|\n)*</now_playing>';$title = $matches[2]
$973fmsong = "{0} – {1}" -f $artist, $title
if((!($973fmresult -eq $973fmsong)) -and `
($973fmsong -notmatch "97.3fm") -and `
($973fmsong -match "..\s-\s..") -and `
($973fmsong -notmatch "Audio Type Changed")){
$973fmresult = $973fmsong
$freshpopsonglist += $973fmsong -replace("[\r|\n]")
}
Write-Host $973fmsong`n
 
#endregion
 
#Write all POP song values to other variable
$capturehourly += ($freshpopsonglist | select –Unique) -replace("`n")
 
#region Send hourly songs to Blogger
if(((Get-Date).Minute -eq "58") -or ((Get-Date).Minute -eq "59") -and (($capturehourly | measure).count -gt "10")){
 
#region Google Blogger API
 
##################################################################################
### If no refresh token – requires human interaction with IE
if(!($refreshToken)){
 
### Get Google API access – https://developers.google.com/identity/protocols/OAuth2WebServer#offline
$scope = "https://www.googleapis.com/auth/blogger"
$response_type = "code"
$approval_prompt = "force"
$access_type = "offline"
 
### Get the authorization code
$auth_string = "https://accounts.google.com/o/oauth2/auth?scope=$scope&response_type=$response_type&redirect_uri=$redirect_uri&client_id=$app_key&access_type=$access_type&approval_prompt=$approval_prompt"
 
$ie = New-Object –comObject InternetExplorer.Application
if($approval_prompt -eq "force"){$ie.visible = $true}
$ie.navigate($auth_string)
#Wait for user interaction in IE, manual approval
do{Start-Sleep 1}until($ie.LocationURL -match 'code=([^&]*)')
$null = $ie.LocationURL -match 'code=([^&]*)'
$authorizationCode = $matches[1]
$ie.Quit()
 
### exchange the authorization code for a refresh token and access token
$grantType = "authorization_code"
$requestUri = "https://accounts.google.com/o/oauth2/token"
$requestBody = "code=$authorizationCode&client_id=$app_key&client_secret=$app_secret&grant_type=$grantType&redirect_uri=$redirect_uri"
 
$response = Invoke-RestMethod –Method Post –Uri $requestUri –ContentType "application/x-www-form-urlencoded" –Body $requestBody
 
$accessToken = $response.access_token
$refreshToken = $response.refresh_token
}
 
##################################################################################
### If refresh token exists
else{
 
### exchange the refresh token for an access token
$grantType = "refresh_token"
$requestUri = "https://accounts.google.com/o/oauth2/token"
$requestBody = "refresh_token=$refreshToken&client_id=$app_key&client_secret=$app_secret&grant_type=$grantType"
 
$response = Invoke-RestMethod –Method Post –Uri $requestUri –ContentType "application/x-www-form-urlencoded" –Body $requestBody
 
$accessToken = $response.access_token
}
 
##################################################################################
 
### Blogger API: Using the API – https://developers.google.com/blogger/docs/3.0/using#AddingAPost
$blogTitle = "ARN-PlayList-" + (Get-Date –format "yyyyMMdd-HHmm")
$songmax = ($capturehourly | Measure-Object).Count
$content = (Get-Date –format g) + "<br><br>Songs played on Brisbane's 973 FM in the past hour. Stations monitored:<br><br>973 FM – Brisbane<br><br>" + (@($capturehourly[0..$songmax]) -join('<br>'))
##################### – http://blogs.technet.com/b/heyscriptingguy/archive/2012/10/08/use-powershell-to-convert-to-or-from-json.aspx
$body = @{
 kind = "blogger#post"
 blog = "id=$blogID"
 title = $blogTitle
 content = $content
}
$json = $body | ConvertTo-Json
####################
$blogurl = $null
$uri = "https://www.googleapis.com/blogger/v3/blogs/4370003358460014533/posts/"
$ContentType = "application/json"
$postblog = Invoke-RestMethod –Method Post –Uri $uri –Body $json –ContentType $ContentType –Headers @{"Authorization"="Bearer $accessToken"}
$blogurl = $postblog.url
 
<# Left in hear for troubleshooting, this is a good way of producing a nice clean output with good information.
Try {
 Invoke-RestMethod -Method Post -Uri $uri -Body $json -ContentType $ContentType -Headers @{"Authorization"="Bearer $accessToken"}
}
Catch {
 Write-Host $_.Exception.ToString()
 $error[0] | Format-List -Force
}
#>
#endregion
 
Start-Sleep –Seconds 5
 
#region Send hourly songs link to Twitter
$message = $TwitterMessage + $blogurl
$Body = "status=$Message"
$HttpEndPoint = "https://api.twitter.com/1.1/statuses/update.json"
$AuthorizationString = Get-OAuthAuthorization –TweetMessage $Message –HttpEndPoint $HttpEndPoint
Invoke-RestMethod –URI $HttpEndPoint –Method Post –Body $Body –Headers @{ 'Authorization' = $AuthorizationString } –ContentType "application/x-www-form-urlencoded"
#endregion
 
$freshpopsonglist = @()
$capturehourly = @()
}
#endregion
 
Start-Sleep –Seconds 20
 
}
 
#endregion
 
function Get-OAuthAuthorization {
 <#
 .SYNOPSIS
 This function is used to setup all the appropriate security stuff needed to issue
 API calls against Twitter's API. It has been tested with v1.1 of the API. It currently
 includes support only for sending tweets from a single user account and to send DMs from
 a single user account.
 .EXAMPLE
 Get-OAuthAuthorization -DmMessage 'hello' -HttpEndPoint 'https://api.twitter.com/1.1/direct_messages/new.json&#39; -Username adam
  
 This example gets the authorization string needed in the HTTP POST method to send a direct
 message with the text 'hello' to the user 'adam'.
 .EXAMPLE
 Get-OAuthAuthorization -TweetMessage 'hello' -HttpEndPoint 'https://api.twitter.com/1.1/statuses/update.json&#39;
  
 This example gets the authorization string needed in the HTTP POST method to send out a tweet.
 .PARAMETER HttpEndPoint
 This is the URI that you must use to issue calls to the API.
 .PARAMETER TweetMessage
 Use this parameter if you're sending a tweet. This is the tweet's text.
 .PARAMETER DmMessage
 If you're sending a DM to someone, this is the DM's text.
 .PARAMETER Username
 If you're sending a DM to someone, this is the username you'll be sending to.
 .PARAMETER ApiKey
 The API key for the Twitter application you previously setup.
 .PARAMETER ApiSecret
 The API secret key for the Twitter application you previously setup.
 .PARAMETER AccessToken
 The access token that you generated within your Twitter application.
 .PARAMETER
 The access token secret that you generated within your Twitter application.
 #>
 [CmdletBinding(DefaultParameterSetName = 'None')]
 [OutputType('System.Management.Automation.PSCustomObject')]
 param (
 [Parameter(Mandatory)]
 [string]$HttpEndPoint,
 [Parameter(Mandatory, ParameterSetName = 'NewTweet')]
 [string]$TweetMessage,
 [Parameter(Mandatory, ParameterSetName = 'DM')]
 [string]$DmMessage,
 [Parameter(Mandatory, ParameterSetName = 'DM')]
 [string]$Username,
 [Parameter()]
 [string]$ApiKey = $TwitterApiKey,
 [Parameter()]
 [string]$ApiSecret = $TwitterApiSecret,
 [Parameter()]
 [string]$AccessToken = $TwitterAccessToken,
 [Parameter()]
 [string]$AccessTokenSecret = $TwitterAccessTokenSecret
 )
  
 begin {
 $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
 Set-StrictMode –Version Latest
 try {
 [Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
 [Reflection.Assembly]::LoadWithPartialName("System.Net") | Out-Null
 } catch {
 Write-Error $_.Exception.Message
 }
 }
  
 process {
 try {
 ## Generate a random 32-byte string. I'm using the current time (in seconds) and appending 5 chars to the end to get to 32 bytes
 ## Base64 allows for an '=' but Twitter does not. If this is found, replace it with some alphanumeric character
 $OauthNonce = [System.Convert]::ToBase64String(([System.Text.Encoding]::ASCII.GetBytes("$([System.DateTime]::Now.Ticks.ToString())12345"))).Replace('=', 'g')
 Write-Verbose "Generated Oauth none string '$OauthNonce'"
  
 ## Find the total seconds since 1/1/1970 (epoch time)
 $EpochTimeNow = [System.DateTime]::UtcNow – [System.DateTime]::ParseExact("01/01/1970", "dd/MM/yyyy", $null)
 Write-Verbose "Generated epoch time '$EpochTimeNow'"
 $OauthTimestamp = [System.Convert]::ToInt64($EpochTimeNow.TotalSeconds).ToString();
 Write-Verbose "Generated Oauth timestamp '$OauthTimestamp'"
  
 ## Build the signature
 $SignatureBase = "$([System.Uri]::EscapeDataString($HttpEndPoint))&"
 $SignatureParams = @{
 'oauth_consumer_key' = $ApiKey;
 'oauth_nonce' = $OauthNonce;
 'oauth_signature_method' = 'HMAC-SHA1';
 'oauth_timestamp' = $OauthTimestamp;
 'oauth_token' = $AccessToken;
 'oauth_version' = '1.0';
 }
 if ($TweetMessage) {
 $SignatureParams.status = $TweetMessage
 } elseif ($DmMessage) {
 $SignatureParams.screen_name = $Username
 $SignatureParams.text = $DmMessage
 }
  
 ## Create a string called $SignatureBase that joins all URL encoded 'Key=Value' elements with a &
 ## Remove the URL encoded & at the end and prepend the necessary 'POST&' verb to the front
 $SignatureParams.GetEnumerator() | sort name | foreach { 
 Write-Verbose "Adding '$([System.Uri]::EscapeDataString(`"$($_.Key)=$($_.Value)&`"))' to signature string"
 $SignatureBase += [System.Uri]::EscapeDataString("$($_.Key)=$($_.Value)&".Replace(',','%2C').Replace('!','%21'))
 }
 $SignatureBase = $SignatureBase.TrimEnd('%26')
 $SignatureBase = 'POST&' + $SignatureBase
 Write-Verbose "Base signature generated '$SignatureBase'"
  
 ## Create the hashed string from the base signature
 $SignatureKey = [System.Uri]::EscapeDataString($ApiSecret) + "&" + [System.Uri]::EscapeDataString($AccessTokenSecret);
  
 $hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
 $hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($SignatureKey);
 $OauthSignature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($SignatureBase)));
 Write-Verbose "Using signature '$OauthSignature'"
  
 ## Build the authorization headers using most of the signature headers elements. This is joining all of the 'Key=Value' elements again
 ## and only URL encoding the Values this time while including non-URL encoded double quotes around each value
 $AuthorizationParams = $SignatureParams
 $AuthorizationParams.Add('oauth_signature', $OauthSignature)
  
 ## Remove any API call-specific params from the authorization params
 $AuthorizationParams.Remove('status')
 $AuthorizationParams.Remove('text')
 $AuthorizationParams.Remove('screen_name')
  
 $AuthorizationString = 'OAuth '
 $AuthorizationParams.GetEnumerator() | sort name | foreach { $AuthorizationString += $_.Key + '="' + [System.Uri]::EscapeDataString($_.Value) + '", ' }
 $AuthorizationString = $AuthorizationString.TrimEnd(', ')
 Write-Verbose "Using authorization string '$AuthorizationString'"
  
 $AuthorizationString
  
 } catch {
 Write-Error $_.Exception.Message
 }
 }
}