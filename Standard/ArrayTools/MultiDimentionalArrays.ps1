# Creating multi-dimensional arays
$TwoDimensionalArray1 = New-Object -TypeName 'object[,]' -ArgumentList  2,3
$TwoDimensionalArray2 = [system.object[,]]::New(2,3)
$ThreeDimensionalArray = [system.object[,,]]::New(2,3,2)

# Assigning values to array elements
$TwoDimensionalArray1[0,1] = Get-Service -Name Spooler
$TwoDimensionalArray2[0,0] = 'harry'
$ThreeDimensionalArray[0,0,0] = 12345