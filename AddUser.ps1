Param (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$SQLUser = 'John',

        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$ServerListPath = ".\ServerName.txt"
)

$ErrorActionPreference = "Stop"
# Install-Module -Name SqlServer
# Get-Credential sa| Export-CliXml  -Path ./MyCredential.xml
Import-Module SqlServer
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
$ServerList = .\helper\ListReader.ps1 $ServerListPath

$db_role = 'db_datareader'
# Start Connection
foreach($Server in $ServerList)
{

    $srv = .\helper\SQLConnect.ps1 $Server
    $sql_secure_pw = .\helper\GenerateRandPW.ps1
    $SqlUserReq = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $srv,"$SQLUser"
    
    if($srv.Logins.Contains("$SQLUser"))
    {
        Throw("User $SQLUser Already Exist")
    }

    $SqlUserReq.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
    $SqlUserReq.PasswordPolicyEnforced = 1

    $SqlUserReq.PasswordExpirationEnabled = $true

    #$SqlUserReq.Create("$sql_secure_pw" )
   
    $SqlUserReq.Create($sql_secure_pw, 2)
    $db = $srv.Databases["master"]

    $SqlUserReq.AddToRole("sysadmin")
    
    foreach ($db in $srv.Databases)
    {
        $database = $srv.Databases[$db.Name]
        $DBUser = [Microsoft.SqlServer.Management.Smo.User]::New($database, "$SQLUser")
        $DBUser.Create()
        $DBUser.AddToRole("$db_role")
        Write-Host("$db_role assigned to $SQLUser in $database")
    }

}

.\helper\SQLClean.ps1 $srv
