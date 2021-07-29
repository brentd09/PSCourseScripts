<#
.Synopsis
  Takes other values in hash table and joins then to current value forming arrays
.DESCRIPTION
  This was in resonse to a question posed and using hash tables
  to create arrays of values that are joined together where the 
  current value is joined to each of the others and stored in an array.
.PARAMETER HashTable
  This is the hashtable that will be used to extract the values to pair up     
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
      one                            {ab, ac}                                                                                            
      two                            {ba, bc}                                                                                            
      three                          {ca, cb}     
.EXAMPLE
  $HashTableInfo = @{one='a';two='b';three='c'}
  Join-HashValues.ps1 -HashTable $HashTableInfo
  This will take a hash table that looks like this:
      Name                           Value                                                                                                  
      ----                           -----                                                                                                  
      one                            a                                                                                            
      two                            b                                                                                            
      three                          c     
   
   It will then produce a hash table that looks like this:
      Name                           Value                                                                                                  
      ----                           -----                                                                                                  
      one                            {ab, ac}                                                                                            
      two                            {ba, bc}                                                                                            
      three                          {ca, cb}           
.EXAMPLE
  Join-HashValues.ps1 -IncludeOriginal
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
Param(
  $HashTable = [ordered]@{
    one=   'a'
    two=   'b'
    three= 'c'
  },
  [switch]$IncludeOriginal 
)

$NewHash = [ordered]@{}
$AllKeys = $HashTable.Keys
foreach ($HashKey in $AllKeys) {
  If ($IncludeOriginal -eq $true) {$NewHash.$HashKey += [array]$HashTable[$HashKey]}
  $OtherKeys = $AllKeys | Where-Object {$_ -notcontains $HashKey}
  foreach ($OtherKey in $OtherKeys) {
    $NewHash.$HashKey += [array](($HashTable[$HashKey, $OtherKey]) -join '')
  }
}
$NewHash