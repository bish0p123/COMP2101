get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | 
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Index" ; width = 20 ; e={$_.index}},
@{n="IPAddress" ; width = 20 ; e={$_.ipaddress}},
@{n="IPSubnet" ; width = 20 ; e={$_.ipsubnet}},
@{n="DNSDomain" ; width = 20 ; e={$_.DNSDomain}},
@{n="DNSServer" ; width = 20 ; e={$_.DNSServerSearchOrder}}