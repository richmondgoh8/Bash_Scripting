$ServerName = $args[0]
Write-Host "Establishing Connections to $ServerName"
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $ServerName
$srv.ConnectionContext.LoginSecure = $false
#$cred = Get-Credential sa
$cred = Import-CliXml -Path .\MyCredential.xml
$srv.ConnectionContext.set_Login($cred.username)
$srv.ConnectionContext.set_SecurePassword($cred.password)
$srv.ConnectionContext.Connect()
Write-Host "Connection has been established"

return $srv
