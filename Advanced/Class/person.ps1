class person {
  [string]$GivenName
  [string]$Surname
  [datetime]$BirthDate
  [string]$CountryOfBirth
  [string]$CountryOfResidence

  person () {
    $this.GivenName = ''
    $this.Surname = ''
    $this.BirthDate = '1 jan 1990'
    $this.CountryOfBirth = ''
    $this.CountryOfResidence = ''
  }

  person ([string]$GivenName,[string]$Surname,[datetime]$BirthDate) {
    $this.GivenName = $GivenName
    $this.Surname = $Surname
    $this.BirthDate = $BirthDate
    $this.CountryOfBirth = 'Australia'
    $this.CountryOfResidence = 'Australia'
  }

  person ([string]$GivenName,[string]$Surname,[datetime]$BirthDate,[string]$CountryOfBirth) {
    $this.GivenName = $GivenName
    $this.Surname = $Surname
    $this.BirthDate = $BirthDate
    $this.CountryOfBirth = $CountryOfBirth
    $this.CountryOfResidence = 'Australia'
  }


  person ([string]$GivenName,[string]$Surname,[datetime]$BirthDate,[string]$CountryOfBirth,[string]$CountryOfResidence) {
    $this.GivenName = $GivenName
    $this.Surname = $Surname
    $this.BirthDate = $BirthDate
    $this.CountryOfBirth = $CountryOfBirth
    $this.CountryOfResidence = $CountryOfResidence
  }

  [int]CalculateAge () {
    $CurrentDate = Get-Date
    return $CurrentDate.Year - $this.BirthDate.Year
  }

  [int]CalculateAge ($GivenYear) {
    return $GivenYear -$this.BirthDate.Year
  }

}