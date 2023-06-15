[xml]$main = '<main></main>'


$NewMove = $main.CreateElement('move')
$main.AppendChild($NewMove)

$main.move.AppendChild($NewMove)