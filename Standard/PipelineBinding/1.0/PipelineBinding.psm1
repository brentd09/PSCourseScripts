function Find-PipelineBindingType {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    $Cmdlet1,
    [Parameter(Mandatory=$true)]
    $Cmdlet2
  )
  foreach ($Cmdlet in @($Cmdlet1,$Cmdlet2)) {
    Write-Verbose "$Cmdlet1, $Cmdlet2, $Cmdlet"
    $CmdletTest = Test-Cmdlet -Cmdlet $Cmdlet
    if ($CmdletTest.Exists -eq $false) {
      throw "The cmdlet $Cmdlet does not exist"
    }
  }
  $CmdletParams     = Get-CmdletParam -Cmdlet $Cmdlet2
  $CmdletObject     = Get-CmdletOutputType -Cmdlet $Cmdlet1
  $CmdletProperties = Get-CmdletOutputProperty -Cmdlet $Cmdlet1
  $TestPipeByVal    = Test-PipelineByVal -Cmdlet1 $Cmdlet1 -Cmdlet2 $Cmdlet2
  if ($TestPipeByVal.ByValPipe -eq $true) {
    Show-PipelineByVal -TestResultByVal $TestPipeByVal
  }
  else {
    $TestPipeByPN = Test-PipelineByPN -Cmdlet1 $Cmdlet1 -Cmdlet2 $Cmdlet2
    if ($TestPipeByPN.ByPNPipe -eq $true) {
      Show-PipelineByPN -TestResultByPN $TestPipeByPN
    }
    else {
      throw 'No Pipeline Binding is possible'
    }
  } 
}

function Test-Cmdlet {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Cmdlet
  )
  $FunctionOutputHash = [ordered]@{ # Assume the Cmdlet exists
    Cmdlet = $Cmdlet
    Exists = $true
  }
  try {Get-command -Name $Cmdlet -ErrorAction stop *> $null}
  catch {$FunctionOutputHash.Exists = $false} # If Cmdlet does not exist change assumed state to false
  return [PSCustomObject]$FunctionOutputHash
}

function Get-CmdletParam {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Cmdlet
  )
  $Params=(Get-Command $Cmdlet).Parameters -as [hashtable]
  [string[]]$Keys =  $Params.Keys
  foreach ($Key in $Params.Keys) {
    $Value = $Params[$key]
    $FunctionOutputHash = [ordered]@{
      Name = $Value.Name 
      FullTypeName = ($Value.ParameterType -replace '\[|\]','') -as [string]
      Type = ($Value.ParameterType.Name -replace '\[|\]','') -as [string]
      ByValue = $Value.Attributes.ValueFromPipeLine
      ByPropertyName = $Value.Attributes.ValueFromPipeLineByPropertyName
      ShowParamType = '-' +  $($Value.Name) +  ' [' +  $($Value.ParameterType.Name -replace '\[|\]','') + ']'
    }
    if ($FunctionOutputHash.ByValue -eq $true -or $FunctionOutputHash.ByPropertyName -eq $true) {
      [PSCustomObject]$FunctionOutputHash # Only return a result if the param accepts pipeline input 
    }
  }
}

function Get-CmdletOutputType {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Cmdlet
  )
  $ResultTypes = Invoke-Expression $Cmdlet | Get-Member | Select-Object -Property TypeName -Unique 
  foreach ($ResultType in $ResultTypes) {
    $FunctionOutputHash = @{
      Cmdlet               = $Cmdlet
      CmdletOutputFullType = $ResultType.TypeName -as [string]
      CmdletOutputType     = (($ResultType.TypeName -Split'\.')[-1]) -as [string]
    }
    [PSCustomObject]$FunctionOutputHash
  }
}

function Get-CmdletOutputProperty {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$Cmdlet
  )
  $ResultTypes = Invoke-Expression $Cmdlet | Get-Member | Select-Object -Property TypeName -Unique
  foreach ($ResultType in $ResultTypes) {
    $CmdletProps = Invoke-Expression $Cmdlet | Get-Member -MemberType Properties
    $CmdletProps | 
      Select-Object -Property Name,
        @{n='ObjectType'; e={$ResultType.TypeName}},
        @{
          n='PropertyType'
          e={
            if ($_.MemberType -ne 'AliasProperty') {
              $FullPropName = ($_.Definition -split ' ')[0] -replace '\[|\]','' 
            }
            else {
              $AliasName = ($_.Definition -split ' ')[-1] -replace '\[|\]','' 
              $FullPropName = (($CmdletProps | Where-Object {$_.name -eq $AliasName}) -split ' ')[0] -replace '\[|\]','' 
            }
            (($FullPropName -split '\.')[-1] -replace '[^a-z]','') -as [string] 
          }
        } | 
        select-object -Property *,@{
          n='ShowPropType'
          e={$TypeName = ($_.PropertyType -split '\.')[-1] -replace '[^a-z]','' ;'[' + $TypeName + ']' + $_.Name}
        }
      
  } # foreach loop end    
}

function Test-PipelineByVal {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    $Cmdlet1,
    [Parameter(Mandatory=$true)]
    $Cmdlet2
  )
  $CmdletOutputTypes = Get-CmdletOutputType -Cmdlet $Cmdlet1
  $CmdletParams = Get-CmdletParam -Cmdlet $Cmdlet2 | Where-Object {$_.ByValue -eq $true}
  foreach ($CmdletOutputType in $CmdletOutputTypes) {
    $ByValParamMatch = $CmdletParams | Where-Object {$_.FullTypeName -eq $CmdletOutputType.CmdletOutputFullType}
    if ($ByValParamMatch) {
      $HashTab = [ordered]@{
        ByValPipe = $true
        Cmdlet1 = $Cmdlet1
        Cmdlet2 = $Cmdlet2
        ParamMatch = $ByValParamMatch
        AllByValParams = $CmdletParams
        OutputType = $CmdletOutputType
      }
    }
    else {
        $HashTab = [ordered]@{
        ByValPipe = $false
        Cmdlet1 = $Cmdlet1
        Cmdlet2 = $Cmdlet2
        ParamMatch = $null
        AllByValParams = $CmdletParams
        OutputType = $CmdletOutputType
      }
    }
    [PSCustomObject]$HashTab
  }  
}

function Test-PipelineByPN {
  [cmdletbinding()]
  Param (
    [Parameter(Mandatory=$true)]
    $Cmdlet1,
    [Parameter(Mandatory=$true)]
    $Cmdlet2
  )
  $CmdletProps  = Get-CmdletOutputProperty -Cmdlet $Cmdlet1
  $CmdletParams = Get-CmdletParam -Cmdlet $Cmdlet2 | Where-Object {$_.ByPropertyName -eq $true}
  foreach ($ByPNParam in $CmdletParams) {
    $MatchingProp = $CmdletProps | Where-Object {
      $_.Name -eq $ByPNParam.Name -and $_.PropertyType -eq $ByPNParam.Type
    }
    if ($MatchingProp) {
      $HashTab = [ordered]@{
        Cmdlet1 = $Cmdlet1
        Cmdlet2 = $Cmdlet2
        ByPNPipe = $true
        PropMatch = $MatchingProp
        ParamMatch = $ByPNParam
        AllProperties = $CmdletProps
      }
    }
    else {
      $HashTab = [ordered]@{
        Cmdlet1 = $Cmdlet1
        Cmdlet2 = $Cmdlet2
        ByPNPipe = $false
        PropMatch = $MatchingProp
        ParamMatch = $null
        AllProperties = $CmdletProps
      }
    }
    [PSCustomObject]$HashTab
  }
}

function Show-PipelineByVal {
  [cmdletbinding()]
  Param (
    $TestResultByVal
  )
  $keyGap = 50
  $Cmdlet1Length = $TestResultByVal.Cmdlet1.Length
  $Cmdlet2Length = $TestResultByVal.Cmdlet2.Length
  $OutputTypeLength = $TestResultByVal.OutputType.CmdletOutputType.Length
  $CommandGap = ' ' * $keyGap
  $GuideGap   = ' ' * ($Cmdlet1Length + $keyGap - 1)
  $MappingGap = '-' * ($keyGap - $OutputTypeLength - 5 ) + '>'
  $HeaderGap  = ' ' * [int]((($keyGap + $Cmdlet1Length) / 2) - 4) 
  Clear-Host
  Write-Host
  Write-Host -ForegroundColor Cyan " $HeaderGap Pipeline ByValue"
  Write-Host -ForegroundColor Cyan " $HeaderGap ----------------"
  Write-Host -ForegroundColor Yellow -NoNewline "$($TestResultByVal.Cmdlet1) " 
  Write-Host -NoNewline "$CommandGap"
  Write-Host -ForegroundColor Green " $($TestResultByVal.Cmdlet2)"
  write-host "  | $GuideGap ^"
  write-host "  | $GuideGap |"
  write-host "  V $GuideGap |"
  foreach ($Param in $TestResultByVal.AllByValParams) {
    Write-Host -NoNewline "  Object Type: "
    Write-Host -ForegroundColor Yellow -NoNewline "$($TestResultByVal.OutputType.CmdletOutputType) "
    if ($TestResultByVal.OutputType.CmdletOutputType -eq $Param.Type) {
      Write-Host -NoNewline $MappingGap
    }
    else {
      Write-Host -NoNewline -ForegroundColor Red ($MappingGap -replace '->','>X') 
    }
    Write-Host -ForegroundColor Green  " $($Param.ShowParamType)"
  }
  Write-Host
  Write-Host
}

function Show-PipelineByPN {
  [cmdletbinding()]
  Param (
    $TestResultByPN
  )
  $KeyGap = 50
  $Cmdlet1Length = $TestResultByPN.Cmdlet1.Length
  $Cmdlet2Length = $TestResultByPN.Cmdlet2.Length
  $OutputTypeLength = $TestResultByPN.OutputType.CmdletOutputType.Length
  $CommandGap = ' ' * ($KeyGap - $Cmdlet1Length + 9)
  $GuideGap   = ' ' * ($Cmdlet1Length + $KeyGap - 4)
  $MappingGap = '-' * ($KeyGap - $OutputTypeLength - 17 ) + '>'
  $HeaderGap  = ' ' * [int]((($KeyGap + $Cmdlet1Length) / 2) - 6) 
  Clear-Host
  Write-Host
  Write-Host -ForegroundColor Cyan " $HeaderGap Pipeline ByPropertyName"
  Write-Host -ForegroundColor Cyan " $HeaderGap -----------------------"
  Write-Host -ForegroundColor Yellow -NoNewline "$($TestResultByPN.Cmdlet1)" 
  Write-Host -NoNewline "$CommandGap"
  Write-Host -ForegroundColor Green " $($TestResultByPN.Cmdlet2)"
  write-host "  | $GuideGap ^"
  write-host "  | $GuideGap |"
  write-host "  V $GuideGap |"
  foreach ($PropToParamMatch in $TestResultByPN) {
    Write-Host -NoNewline '  Property: '
    Write-Host -ForegroundColor Yellow -NoNewline "$($PropToParamMatch.PropMatch.ShowPropType) "
    Write-Host -NoNewline "$MappingGap"
    Write-Host -ForegroundColor Green " $($TestResultByPN.ParamMatch.ShowParamType)"
  }
  foreach ($NonMatchingPropery in ($TestResultByPN.AllProperties | Where-Object {$_.Name -notin $TestResultByPN.PropMatch.Name})) {
    Write-Debug nonmatch
    Write-Host -NoNewline '  Property: '
    Write-Host -ForegroundColor Yellow -NoNewline  "$($NonMatchingPropery.ShowPropType) "
    $NonMapGuide = ('-' * (44 - $($NonMatchingPropery.ShowPropType.length))) + '>X'
    Write-Host -NoNewline -ForegroundColor Red "$NonMapGuide"
    Write-Host -ForegroundColor Green " No-Matching-Parameter"    
  }
  Write-Host
  Write-Host
}
