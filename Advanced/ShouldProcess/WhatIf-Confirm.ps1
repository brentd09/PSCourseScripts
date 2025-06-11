function Remove-User {
  [CmdletBinding(SupportsShouldProcess=$true)]
  param (  )
  
  begin {  }
  process {
    $Person = [PSCustomObject]@{
      Name = 'Bob'
    }
    if ($PSCmdlet.ShouldProcess($Person.Name)) {
      Write-Host "Delete $($Person.Name)"
    }
    if ($PSCmdlet.ShouldProcess($Person.Name,"Removing the user from the user database")) {
      Write-Host "Delete $($Person.Name)"
    }
    if ($PSCmdlet.ShouldProcess("This would have performed a deletion of the the user $($Person.Name)",$Person.Name,"Removing the user from the company database")) {
      Write-Host "Delete $($Person.Name)"
    }
  }
  end {  }
}

Remove-User -Whatif
Remove-USer -Confirm
