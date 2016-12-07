
icacls C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys > "$env:temp\current_MachineKeys_permissions.txt"
get-content "$env:temp\current_MachineKeys_permissions.txt"
takeown /f C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\f686aace6942fb7f7ceb231212eef4a4_*
icacls C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\f686aace6942fb7f7ceb231212eef4a4_* /grant "NT AUTHORITY\SYSTEM:(F)"
icacls C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\f686aace6942fb7f7ceb231212eef4a4_* /grant "NT AUTHORITY\NETWORK SERVICE:(R)"
icacls C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\f686aace6942fb7f7ceb231212eef4a4_* /grant "BUILTIN\Administrators:(R)"
restart-service TermService -Force