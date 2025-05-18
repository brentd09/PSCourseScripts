class PGNInterpreter {
  [string]$PgnString
  [hashtable]$Metadata = @{}
  [string[]]$Moves = @()

  PGNInterpreter([string]$pgnString) {
      $this.PgnString = $pgnString
  }

  [void]Parse() {
      $moveText = @()

      $lines = $this.PgnString -split "`r`n"
      foreach ($line in $lines) {
          $line = $line.Trim()
          if ($line -match '^\[(\w+)\s+"(.+)"\]$') {
              $tag = $matches[1]
              $value = $matches[2]
              $this.Metadata[$tag] = $value
          }
          elseif ($line -ne "") {
              $moveText += $line
          }
      }

      $allMoves = $moveText -join " "
      $this.Moves = $allMoves -split '\s+'
  }

  [void]Display() {
      Write-Host "Metadata:"
      foreach ($key in $this.Metadata.Keys) {
          Write-Host "${key}: $($this.Metadata[$key])"
      }
      Write-Host "`nMoves:"
      Write-Host ($this.Moves -join " ")
  }
}

# Example usage
$pgn = @"
[Event "World Championship"]
[Site "Reykjavik, Iceland"]
[Date "1972.07.11"]
[Round "6"]
[White "Fischer, Robert J."]
[Black "Spassky, Boris V."]
[Result "1-0"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6
8. c3 O-O 9. h3 Nb8 10. d4 Nbd7 11. c4 Bb7 12. Nbd2 Re8 13. Bc2 Bf8 14. b4 g6
15. a3 Bg7 16. d5 c6 17. dxc6 Bxc6 18. Bd3 Nb6 19. cxb5 Bxb5 20. Bxb5 axb5
21. Bb2 Qd7 22. Qe2 Na4 23. Rab1 Nxb2 24. Rxb2 Rxa3 25. Nb1 Ra1 26. Nc3 Rxe1+
27. Qxe1 d5 28. exd5 e4 29. Nd4 Nxd5 30. Nxd5 Qxd5 31. Rd2 Qc4 32. Nc2 Bc3
33. Ne3 Qxb4 34. Nd5 Bxd2 35. Nf6+ Kh8 36. Qxd2 Qxd2 37. Nxe8 Qe1+ 38. Kh2 Qxf2
39. Nf6 e3 40. Ng4 Qf4+ 41. g3 Qd4 42. Nxe3 Qxe3 43. h4 b4 44. Kh3 b3 45. h5 gxh5
46. Kh4 Qe2 47. Kh3 f5 48. g4 hxg4+ 49. Kh4 Qh2+ 50. Kg5 Qe5 51. Kh6 Qe8
52. Kg5 Qg6+ 53. Kh4 g3 54. Kh3 g2 55. Kh4 g1=Q 56. Kh3 f4 57. Kh4 Qh6#
1-0
"@

$interpreter = [PGNInterpreter]::new($pgn)
$interpreter.Parse()
$interpreter.Display()