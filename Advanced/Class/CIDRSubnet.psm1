Class CidrMask {
  [int]$CidrMask
  [string]$DotDecMask
  [int]$SubnetsJumpBy
  [int]$JumpAtBit  

  CidrMask ([int]$MaskLength) {
    $NumFullMaskOctets = [math]::Truncate($MaskLength/8)
    $SubBits = $MaskLength % 8
    $HiOrdHostBit = 8 - $SubBits
    if ($SubBits -eq 0) {
      $JumpBy = 1
      $JumpBit = $NumFullMaskOctets
    }
    else {
      $JumpBy = [math]::Pow(2,$HiOrdHostBit)
      $JumpBit = $NumFullMaskOctets + 1
    }
    $HostBits = [math]::Pow(2,$HiOrdHostBit)-1
    $MaskforOctet = $HostBits -bxor 255
    $DotMask = ("255."*$NumFullMaskOctets)+$MaskforOctet+(".0"*(4-($NumFullMaskOctets+1)))  
    $this.CidrMask      = $MaskLength
    $this.DotDecMask    = $DotMask
    $this.SubnetsJumpBy = $JumpBy
    $this.JumpAtBit     = $JumpBit
    }   
}

$subnetInfo = [CidrMask]::New(23)
