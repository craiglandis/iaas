<#
    For expired self signed certs, this removes the cert from the store, the linked key file, 
    and bounces termservices to regenerate a new one to keep other services in production. 
    Most run it manually in chunks but it works through CSE or pushed all at once from remote powershell;
#>

#sets the Certificate Store path
$path = get-childitem -Recurse 'Cert:\LocalMachine\Remote Desktop'
 
#Check the certificate date
$path.NotAfter
 
#sets the thumbprint from the cert
$thumb = $path | select-object -ExpandProperty Thumbprint
 
#pulls just the Machine Key Name based thumbprint
$cert = $path.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
 
#Machine key properties based on the thumbprint
$key = get-childItem 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys' | where-Object {$_.Name -eq $cert}
   
#Removes the certificate
remove-item -path "Cert:\LocalMachine\Remote Desktop\$thumb"
 
#deletes the key
$key | % { $_.Delete() }
 
#restart the service to generate a new cert
restart-service TermService -force