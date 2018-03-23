
Describe "Get-ShortHash" {
  It 'Converts a long hash to a 7 character hash' {
    $Hash = 'ca146ab4231afed311de6423aa23'
    Get-ShortHash -Hash $Hash |
      should Be 'ca146ab'
  }

}