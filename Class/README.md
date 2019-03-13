# Classes in PowerShell


### Classes can be created in PowerShell 5.0 and later.

Classes can be created in scripts and in modules. However these Classes can not be used by
other scripts and modules.

### Share Classes
We have had the ability in PowerShell to import other modules for some time now with the 
Import-Module command, however while this successfully imports the functions from a 
module it does not import any Classes created in that module.

To share classes you can create a module file ps
