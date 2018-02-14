### When looking for error types do the following
### Create the error, then use:
### $error[0].Exception.GetType().fullname
### This command will find the error type used in the Catch statement 

Try {
  Get-ChildItem $env:TMP\test123 -ErrorAction stop
}
Catch [System.Management.Automation.ItemNotFoundException] {
  "The error was relating to the item not being located"
}
Catch {
  "The error was somthing else"
}