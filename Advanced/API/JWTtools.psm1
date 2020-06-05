function New-JsonWebToken {
    <#
  .Synopsis
     Creates a JSON Web Token
  .DESCRIPTION
     by entering the required information this command 
     creates a JWT that will be valid for the number of
     seconds specified
  .EXAMPLE
     $ApiKey = '1234'
     $ApiSecret = '1243'
     New-JsonWebToken -Algorithm 'HS256' -Type 'JWT' -ApiKey $ApiKey -ApiSecret $ApiSecret -ValidforSeconds 30   

     This creates a JWT with these attributes
  .PARAMETER Algorithm
     Specify the hashing algorithm required
     either "HS256", "HS384" or "HS512"
  .PARAMETER Type
     This will be the type of token in this case the one option is "JWT"
  .PARAMETER ApiKey
     This refers to the the API key
  .PARAMETER ApiSecret
     This refers to the API Secret
  .PARAMETER ValidforSeconds
     This gives a time stamp to the code so that it cannot be reissued by someone else
     at a later time (replay attack)
  .NOTES
     General notes
       Adapted code from: "u/ping_localhost"
       Date: 5-Jun-2020
  #>
  Param (
    [ValidateSet("HS256", "HS384", "HS512")]
    [string]$Algorithm = "HS256",

    [ValidateSet("JWT")]
    [string]$Type = "JWT",
    
    [Parameter(Mandatory=$True)]
    [string]$ApiKey,

    [Parameter(Mandatory = $True)]
    [string]$ApiSecret,

        
    [int]$ValidforSeconds = 30

  )

  $Expiration = [int][double]::parse((Get-Date -Date $((Get-Date).addseconds($ValidforSeconds).ToUniversalTime()) -UFormat %s)) # Grab Unix Epoch Timestamp and add desired expiration.
  $Header = @{
    alg = $Algorithm
    typ = $Type
  }
  $Payload = @{
    iss = $ApiKey
    exp = $Expiration
  }
  $HeaderJson = $Header | ConvertTo-Json -Compress
  $PayloadJson = $Payload | ConvertTo-Json -Compress
  $HeaderJsonBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($HeaderJson)).Split('=')[0].Replace('+', '-').Replace('/', '_')
  $PayloadJsonBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($PayloadJson)).Split('=')[0].Replace('+', '-').Replace('/', '_')
  $ToBeSigned = $HeaderJsonBase64 + "." + $PayloadJsonBase64
  $SigningAlgorithm = switch ($Algorithm) {
    "HS256" {New-Object System.Security.Cryptography.HMACSHA256}
    "HS384" {New-Object System.Security.Cryptography.HMACSHA384}
    "HS512" {New-Object System.Security.Cryptography.HMACSHA512}
  }
  $SigningAlgorithm.Key = [System.Text.Encoding]::UTF8.GetBytes($ApiSecret)
  $Signature = [Convert]::ToBase64String($SigningAlgorithm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ToBeSigned))).Split('=')[0].Replace('+', '-').Replace('/', '_')
  $Token = "$HeaderJsonBase64.$PayloadJsonBase64.$Signature"
  $ValidUntil = (Get-Date).AddSeconds($ValidforSeconds)
  $OutputHash = [ordered]@{
     ApiKey = $ApiKey
     TokenType = $Type
     HashAlgorithm = $Algorithm
     ValidUntil = $ValidUntil
     Token = $Token
  }
  $ReturnObj = New-Object -TypeName psobject -Property $OutputHash
  return $ReturnObj
} 