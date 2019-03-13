Classes in PowerShell
----------------------------------------------

When creating classes that need to be used by many modules, you can 
create a module that just creates the base classes and then place that 
module in an auto-loading directory (See $Env:PSModulePath)

In the modules that will use the classes use the following syntax:
Using Module <ModuleName>
Place this at the top on the module that will use these classes defined
in module declared in the Using statement
