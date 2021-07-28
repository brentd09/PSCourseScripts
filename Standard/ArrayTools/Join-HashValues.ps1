<#
.Synopsis
   Takes other values in hash table and joins then to current value forming arrays
.DESCRIPTION
   This was in resonse to a question posed and using hash tables
   to create arrays of values that are joined together where the 
   current value is joined to each of the others and stored in an array.
.NOTES
   General notes
     Created By: Brent Denny
     Created On: 28 Jul 2021
.EXAMPLE
    Join-HashValues.ps1
    This will take a hash table that looks like this:
       Name                           Value                                                                                                  
       ----                           -----                                                                                                  
       one                            a                                                                                            
       two                            b                                                                                            
       three                          c     
    
    It will then produce a hash table that looks like this:
       Name                           Value                                                                                                  
       ----                           -----                                                                                                  
       one                            {a, ab, ac}                                                                                            
       two                            {b, ba, bc}                                                                                            
       three                          {c, ca, cb}     
#>
[CmdletBinding()]
Param()
$Hash = [ordered]@{
  one=   'a'
  two=   'b'
  three= 'c'
}
$NewHash = [ordered]@{}
$AllKeys = $Hash.Keys
foreach ($HashKey in $AllKeys) {
  $NewHash.$HashKey += [array]$Hash[$HashKey]
  $OtherKeys = $AllKeys | Where-Object {$_ -notcontains $HashKey}
  foreach ($OtherKey in $OtherKeys) {
    $NewHash.$HashKey += [array](($Hash[$HashKey, $OtherKey]) -join '')
  }
}
$NewHash