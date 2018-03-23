function Format-Env {
  Param ($Name)
  ($Name -creplace "([A-Z])",'_$1').TrimStart('_').ToUpper()
}

