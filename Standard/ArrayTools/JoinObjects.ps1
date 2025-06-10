function Join-ObjectProperty {
  [cmdletbinding()]
  Param ()
  $Collection1 = @(
    [PSCustomObject]@{ Name = 'Object1'; Value = 10 }
    [PSCustomObject]@{ Name = 'Object2'; Value = 20 }
  )
  $Collection2 = @(
    [PSCustomObject]@{ Description = 'Desc1'; Amount = 100 }
    [PSCustomObject]@{ Description = 'Desc2'; Amount = 200 }
  )

  
  if ($collection1.count -eq $collection2.count) {
    $ObjectCount = $collection1.count
    $IndexArray = 0..($ObjectCount-1)
    $CombinedObject = foreach ($Index in $IndexArray) {
      [PSCustomObject]@{
        Name        = $collection1[$Index].Name
        Value       = $collection1[$Index].Value
        Description = $collection2[$Index].Description
        Amount      = $collection2[$Index].Amount
      }
    }
    return $CombinedObject
  }
}

Join-ObjectProperty
