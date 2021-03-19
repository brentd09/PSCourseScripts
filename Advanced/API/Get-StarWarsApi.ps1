
$StarWarsPeople    = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/people/'
$StarWarsPlanets   = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/planets/'
$StarWarsFilms     = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/films/'
$StarWarsSpecies   = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/species/'
$StarWarsVehicles  = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/vehicles/'
$StarWarsStarships = Invoke-RestMethod -Method Get -UseBasicParsing -Uri 'http://swapi.dev/api/starships/'

$StarWarsDB = @{
  People   = $StarWarsPeople.results    
  Planets  = $StarWarsPlanets.results
  Films    = $StarWarsFilms.results     
  Species  = $StarWarsSpecies.results   
  Vehicles = $StarWarsVehicles.results  
  Starships = $StarWarsStarships.results
} 

$StarWarsDB