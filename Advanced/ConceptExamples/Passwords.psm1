function Compare-Password {
  Param (
    [Parameter(dontshow)]
    [securestring]$Password = (Read-Host -Prompt "Enter a password" -AsSecureString),
    [Parameter(dontshow)]
    [securestring]$Confirm = (Read-Host -Prompt "Confirm the password" -AsSecureString)
  )  
 
  $ClearPswd = [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($Password))
  $ClearCnfm = [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($Confirm))
  if ($ClearPswd -eq $ClearCnfm) {Write-Host -ForegroundColor Green "The passwords match"}
  else {Write-Host -ForegroundColor Red "The passwords do not match"}
}  

<#
  This C# code was the basis for the content above
  Use the System.Runtime.InteropServices.Marshal class:

String SecureStringToString(SecureString value) {
  IntPtr valuePtr = IntPtr.Zero;
  try {
    valuePtr = Marshal.SecureStringToGlobalAllocUnicode(value);
    return Marshal.PtrToStringUni(valuePtr);
  } finally {
    Marshal.ZeroFreeGlobalAllocUnicode(valuePtr);
  }
}

#>