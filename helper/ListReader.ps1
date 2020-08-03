Param (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [String]$serverListPath = ".\ServerName.txt"
)

$ServerNameList = (get-content -path $serverListPath).Split('#')
return $ServerNameList
foreach($ServerName in $ServerNameList)
{
Write-Host("Server: $ServerName Found")
}