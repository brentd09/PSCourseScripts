### When looking for error types do the following
### Create the error, then use:
### $error[0].Exception.GetType().fullname
### This command will find the error type used in the Catch statement 

Try {
  Get-Content $env:TMP\test123 -ErrorAction stop
}
Catch [System.Management.Automation.ItemNotFoundException] {
  "The error was relating to the item not being located"
}
Catch [System.UnauthorizedAccessException] {
  "The error was relating to a lack of permissions"
}
Catch {
  "The error was somthing else"
}


