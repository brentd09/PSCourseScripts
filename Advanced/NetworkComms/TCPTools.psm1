﻿# Copied from https://riptutorial.com/powershell/example/18118/tcp-sender

Function Send-TCPMessage { 
  Param ( 
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()] 
    [string]$EndPoint,
    [Parameter(Mandatory=$true, Position=1)]
    [int]$Port,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$Message
  ) 
  Process {
    # Setup connection 
    $IP = [System.Net.Dns]::GetHostAddresses($EndPoint) 
    $Address = [System.Net.IPAddress]::Parse($IP) 
    $Socket = New-Object System.Net.Sockets.TCPClient($Address,$Port) 
  
    # Setup stream wrtier 
    $Stream = $Socket.GetStream() 
    $Writer = New-Object System.IO.StreamWriter($Stream)

    # Write message to stream
    $Message | ForEach-Object {
      $Writer.WriteLine($_)
      $Writer.Flush()
    }
  
    # Close connection and stream
    $Stream.Close()
    $Socket.Close()
  }
}

Function Receive-TCPMessage {
  Param ( 
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()] 
    [int]$Port
  ) 
  Process {
    Try { 
      # Set up endpoint and start listening
      $endpoint = new-object System.Net.IPEndPoint([ipaddress]::any,$port) 
      $listener = new-object System.Net.Sockets.TcpListener $EndPoint
      $listener.start() 

      # Wait for an incoming connection 
      $data = $listener.AcceptTcpClient() 
  
      # Stream setup
      $stream = $data.GetStream() 
      $bytes = New-Object System.Byte[] 1024

      # Read data from stream and write it to host
      while (($i = $stream.Read($bytes,0,$bytes.Length)) -ne 0){
        $EncodedText = New-Object System.Text.ASCIIEncoding
        $data = $EncodedText.GetString($bytes,0, $i)
        Write-Output $data
      }
   
      # Close TCP connection and stop listening
      $stream.close()
      $listener.stop()
    }
    Catch {
      "Receive Message failed with: `n" + $Error[0]
    }
  }
}
