Param(
   [Parameter(Position=1)]
   [switch]$drives ,
  
   [Parameter(Position=2)]
   [switch]$network ,
 
   [Parameter(Position=3)]
   [switch]$system

)

if ($system) {
get-ciminstance win32_computersystem | 
	foreach {
		New-Object -TypeName psobject -Property @{
			"Hardware Description" = $_.Description
		}
		} |
		Format-List "Hardware Description"

get-ciminstance win32_operatingsystem | 
	foreach {
		New-Object -TypeName psobject -Property @{
			"System Name" = $_.name
			"Version Number" = $_.version
		}
		} |
		Format-List "System Name", "Version Number"

get-ciminstance win32_processor | 
	foreach {
		New-Object -TypeName psobject -Property @{
			"Description" = $_.description
			"Max Clock Speed" = $_.maxclockspeed
			"Number of Cores" = $_.numberofcores
			"L1 Cache Size" = $_.l1cachesize
			"L2 Cache Size" = $_.l2cachesize
			"L3 Cache Size" = $_.l3cachesize
		}
		} |
		Format-List "Description", "Max Clock Speed", "Number of Cores", "L1 Cache Size", "L2 Cache Size", "L3 Cache Size"

get-ciminstance win32_physicalmemory | 
	foreach {
		New-Object -TypeName psobject -Property @{
			"Description" = $_.description
			"Vendor" = $_.partnumber
			"Size" = $_.capacity
			"Bank Slot" = $_.banklabel
			"Capacity" = $_.capacity
		}
		} |
		Format-Table "Description", "Vendor", "Size", "Bank Slot", "Capacity"
} 

if ($network) {
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled |
	foreach {
		New-Object -TypeName psobject -Property @{
			"Description" = $_.description
			"Index" = $_.index
			"IP Address" = $_.ipaddress
			"IP Subnet" = $_.ipsubnet
			"DNS Domain" = $_.DNSDomain
			"DNS Server" = $_.DNSServerSearchOrder
		}
		} |
		Format-Table "Description", "Index", "IP Address", "IP Subnet", "DNS Domain", "DNS Server"
}

if ($drives) {
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
}