Param (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$Server = "192.168.0.129,1433\SQLEXPRESS01"
)

$ErrorActionPreference = "Stop"
# Install-Module -Name SqlServer
# Get-Credential sa| Export-CliXml  -Path ./MyCredential.xml
Import-Module SqlServer
# Start Connection
$srv = .\helper\SQLConnect.ps1 $Server

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

Try
{
$db = $srv.Databases["master"]
$ds = $db.ExecuteWithResults("SELECT @@version")
$dt = $ds.Tables[0].Rows[0]["Column1"]
$dt
}
Catch
{
Throw "Error Interfacing with Database"
}
Finally
{
.\helper\SQLClean.ps1 $srv
}