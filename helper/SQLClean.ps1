$srv = $args[0]
$srv.ConnectionContext.Disconnect()
Write-Host("Disconnecting from $srv")