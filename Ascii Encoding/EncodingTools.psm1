function Convertto-Base64 {
  Param (
    [Parameter(Mandatory=$true)]
    [string]$TextToConvert
  )
  $Bytes = [System.Text.Encoding]::UTF8.GetBytes($TextToConvert)
  $Base64 = [System.Convert]::ToBase64String($Bytes)
  $ObjProp = [ordered]@{
    Text = $TextToConvert
    Base64 = $Base64
  }
  New-Object -TypeName psobject -Property $ObjProp
}

function ConvertFrom-Base64 {
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Base64String
  )
  $Bytes = [System.Convert]::FromBase64String($Bas64String)
  $EncodingType = [System.Text.Encoding]::ASCII
  $ASCIIString = $EncodingType.GetString($Bytes)
  $ObjProp = [ordered]@{
    Text = $ASCIIString
    Base64 = $Base64String
  }
  New-Object -TypeName psobject -Property $ObjProp
}