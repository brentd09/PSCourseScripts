## This is a very simple example of an API that that can take incoming requests with the correct formatted data and respond accordingly
## The API JSON must be in this format
## {
##   GivenName = "Brent",
##   Surname = "Denny"
## }
##  


function Start-GreetingAPI {
  $port = 8080
  $listener = New-Object System.Net.HttpListener
  $listener.Prefixes.Add("http://localhost:$port/")
  $listener.Start()

  Write-Host "API listening on http://localhost:$port/"
  Write-Host "Press Ctrl+C to stop."

  try {
    while ($listener.IsListening) {
      # Wait for an incoming request
      $context = $listener.GetContext()
      $request = $context.Request
      $response = $context.Response

      if ($request.HttpMethod -eq 'POST') {
        # Read the incoming JSON body
        $reader = New-Object System.IO.StreamReader($request.InputStream)
        $body = $reader.ReadToEnd()
        try {
          # Parse the JSON payload
          $payload = $body | ConvertFrom-Json
          $givenName = $payload.GivenName
          $surname = $payload.Surname

          # Construct the response object
          $responseData = @{
            greeting = "Hello $givenName $surname"
          }
                
          $jsonResponse = $responseData | ConvertTo-Json -Depth 2
          $response.StatusCode = 200  
        } 
        catch {
          $jsonResponse = @{ error = "Invalid JSON or missing properties." } | ConvertTo-Json
          $response.StatusCode = 400
        }  
      } 
      else {
        $jsonResponse = @{ error = "Only POST requests are supported." } | ConvertTo-Json
        $response.StatusCode = 405
      }

      # Send the JSON response
      $buffer = [System.Text.Encoding]::UTF8.GetBytes($jsonResponse)
      $response.ContentType = "application/json"
      $response.ContentLength64 = $buffer.Length
      $response.OutputStream.Write($buffer, 0, $buffer.Length)
      $response.Close()
    }
  } 
  finally {
    $listener.Stop()
    $listener.Close() 
  }
}

function Invoke-GreetingClient {
  $body = @{
      GivenName = "Brent"
      Surname = "Denny"
  } | ConvertTo-Json
  Invoke-RestMethod -Uri "http://localhost:8080/" -Method Post -Body $body -ContentType "application/json"
}
