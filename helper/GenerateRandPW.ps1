Add-Type -AssemblyName 'System.Web'
$minLength = 8 ## characters
$maxLength = 12 ## characters
$length = Get-Random -Minimum $minLength -Maximum $maxLength
$nonAlphaChars = Get-Random -Minimum 3 -Maximum ($maxLength-3)
$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
Write-Host($password)
$secPw = ConvertTo-SecureString -String $password -AsPlainText -Force
return $secPw