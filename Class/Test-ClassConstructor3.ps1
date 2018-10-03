class DiskInfo {
  #Properties
  [string]$DriveLetter
  [double]$DiskSize
  [double]$FreeSpace
  [int]$NumberOfFiles
  
  #constructors
  DiskInfo ($DriveLetter) {
    $this.DiskSize = (Get-Volume -DriveLetter $DriveLetter).Size
    $this.FreeSpace = (Get-Volume -DriveLetter $DriveLetter).SizeRemaining
    $this.DriveLetter = $DriveLetter
    $this.NumberOfFiles = (Get-ChildItem -Path ($DriveLetter+':\') -File -Recurse | Measure-Object).Count
  }
}

[DiskInfo]::New('c')