# Classes in PowerShell


## Classes can be created in PowerShell 5.0 and later.

Classes can be created in scripts and in modules. However these Classes can not be used by
other scripts and modules.

## Share Classes
We have had the ability in PowerShell to import other modules for some time now with the 
Import-Module command, however while this successfully imports the functions from a 
module it does not import any Classes created in that module.

To share classes you can create a module file do the following:
1. Create a module and declare the classes within it.
2. Save this module in an autoloading folder
3. Create another module in which you would like to use the Classes from Step 1
4. At the top of the module file use the "**USING Module** ModuleName" command.

The USING command will not only load the module it will also import any classes as well.
