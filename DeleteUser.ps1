Param (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$SQLUser = 'John',

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

# Start Process Code

if ($srv.Logins.Contains($SQLUser)) 
{   
    foreach ($db in $srv.Databases)
    {
        if ($db.Users.Contains($SQLUser))
        {
            $db.Users["$SQLUser"].Drop();
            Write-Host("Deleting $SQLUser from $db")
        }
    }

	Write-Host("Deleting the existing Server login $SQLUser.")
    $db = $srv.Databases["master"]
    #$ds = $db.ExecuteWithResults("SELECT session_id FROM sys.dm_exec_sessions WHERE login_name = 'Tim'")
    $ds = $db.ExecuteWithResults("SELECT session_id FROM sys.dm_exec_sessions WHERE login_name = '$SQLUser'")
    
    #$dt = $ds.Tables[0].Rows[0].session_id
    $dt = $ds.Tables[0]
    $dr = $dt.Rows[0].session_id
    
    if ($dt.Rows.Count -ge 0) {
        Write-Host("Have Data")
        foreach ($session_id in $dt) {
            # Drop Connections If Any
            $sid = $session_id.session_id
            Write-Host("Destroying $sid")
            $db.ExecuteNonQuery("Kill $sid")
        }
    }
    $db.ExecuteNonQuery("DROP LOGIN [$SQLUser]")
}

# End Process Code

.\helper\SQLClean.ps1 $srv