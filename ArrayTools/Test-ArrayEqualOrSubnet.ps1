$A = 1,2,3,5
$B = 1,2,3,4

$AB = $A | where {$_ -notin $B}
$BA = $B | where {$_ -notin $A}

if     ($AB -eq $null -and $BA -eq $null) {'$A and $B arrays are the same'}
elseif ($AB -eq $null -and $BA -ne $null) {'$A is a subset of $B'}
elseif ($AB -ne $null -and $BA -eq $null) {'$B is a subset of $A'}
elseif ($AB -ne $null -and $BA -ne $null) {'$A and $B are not equal or subsets of each other'}

