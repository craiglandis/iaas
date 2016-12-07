reg delete "HKLM\SYSTEM\CurrentControl\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules\DomainProfile" /v "DoNotAllowExceptions" /f
reg delete "HKLM\SYSTEM\CurrentControl\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules\PublicProfile" /v "DoNotAllowExceptions" /f
reg delete "HKLM\SYSTEM\CurrentControl\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules\StandardProfile" /v "DoNotAllowExceptions" /f 
