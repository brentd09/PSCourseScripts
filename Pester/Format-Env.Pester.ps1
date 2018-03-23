Describe {
  It "Converts '<value' to '<expected>'" -TestCases @(
    @{Value = 'BigData';Expected = 'Big_Data'}
    @{Value = 'ABC';Expected = 'A_B_C'}
  ) {
    Param ($Value,$Expected)

    Format-Env $Value |
      should Be $Expected
  }

}