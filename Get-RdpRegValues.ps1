param(
[switch]$setDefault
)

$portNumber = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber').PortNumber
$fDenyTSConnections = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections').fDenyTSConnections

$domainProfile = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -Name 'EnableFirewall').EnableFirewall
$publicProfile = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -Name 'EnableFirewall').EnableFirewall
$standardProfile = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile' -Name 'EnableFirewall').EnableFirewall

write-host "PortNumber: $portNumber"
write-host "fDenyTSConnections: $fDenyTSConnections"
write-host "DomainProfile: $domainProfile"
write-host "publicProfile: $publicProfile"
write-host "standardProfile: $standardProfile"

if ($setDefault)
{
    write-host "Setting PortNumber to 3389 because -setDefault parameter is $setDefault"
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name 'PortNumber' -Value '3389'
}