import-module .\EnvFormatTools.psm1
Import-Module .\HashTools.psm1

invoke-pester -Script .\Format-Env.Pester.ps1 -TestName EnvFormat

invoke-pester -Script .\Get-ShortHash.Pester.ps1 -TestName GetShortHash