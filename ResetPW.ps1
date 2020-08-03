Param (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$SQLUser = 'Tim',

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

$sql_secure_pw = .\helper\GenerateRandPW.ps1

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

if(-Not $srv.Logins.Contains("$SQLUser"))
{
    Throw("User $SQLUser Doesn't Exist")
}

$db = $srv.Databases["master"]
$db.ExecuteNonQuery("ALTER LOGIN Tim WITH PASSWORD = 'test' MUST_CHANGE")
.\helper\SQLClean.ps1 $srv