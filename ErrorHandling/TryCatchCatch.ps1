### When looking for error types do the following
### Create the error, then use:
### $error[0].Exception.GetType().fullname
### This command will find the error type used in the Catch statement 

Try {
  Get-Content $env:TMP\test123 -ErrorAction stop
  Write-Host "If there was an error in the get-content command this line will not execute"
}
Catch [System.Management.Automation.ItemNotFoundException] {
  "The error was relating to the item not being located"
  Write-Error $_
}
Catch [System.UnauthorizedAccessException] {
  "The error was relating to a lack of permissions"
}
Catch {
  "The error was somthing else"
  
}
finally {
  read-host -Prompt "ENTER to continue"
}
# The terminating error in the Try-Catch does not terminate
# the script, just the try block and triggers the catch.
# Hence this following line will run whether there was an error or not
Get-Service

