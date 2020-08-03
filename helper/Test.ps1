#secedit.exe /export /cfg D:\security-policy.inf

$cred = Get-Credential test
ping 192.168.0.129

Invoke-Command –ComputerName 192.168.0.129 -ScriptBlock {Hostname}

#Invoke-Command -ComputerName 192.168.0.129 -Credential $cred {Get-Service}
#enter-psssession -computer 192.168.0.129 -credential $cred
#Enter-PSSession -ComputerName '192.168.0.129' -Authentication Basic -Credential $cred 