$Input = Read-Host "Please enter your password. `nPassword must meet complexity requirements:  
`nAt least one upper case English letter [A-Z]`nAt least one lower case English letter [a-z]`nAt least one digit [0-9]`nAt least one special character (!,@,%,^,&,$,_)`nPassword length must be 7 to 25 characters." 

if(($input -cmatch '[a-z]') -and ($input -cmatch '[A-Z]') -and ($input -match '\d') -and ($input.length -match '^([7-9]|[1][0-9]|[2][0-5])$') -and ($input -match '!|@|#|%|^|&|$|_')) 
{ 
    Write-Output "$input is valid password" 
    return $true
} 
else 
{ 
    Write-Output "$input is Invalid paasword" 
    return $false
}