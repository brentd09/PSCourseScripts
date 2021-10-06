$Activity = Invoke-RestMethod -Uri 'https://www.boredapi.com/api/activity/'
$Activity  | Select-Object *


$AgeGuess = Invoke-RestMethod -Uri 'https://api.agify.io/?name=Brian'
$AgeGuess | Select-Object *


$Starships = Invoke-RestMethod -Uri 'https://swapi.dev/api/starships/'
$Starships.Results | Select-Object *