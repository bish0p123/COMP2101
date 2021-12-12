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


get-ciminstance win32_computersystem | 
format-table @{n="Hardware Description" ; width = 15 ; e={$_.description}}

get-ciminstance win32_operatingsystem | 
format-table @{n="System Name" ; width = 15 ; e={$_.name}},
@{n="Version Number" ; width = 20 ; e={$_.version}}

get-ciminstance win32_processor | 
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Speed" ; width = 20 ; e={$_.maxclockspeed}},
@{n="Number of Cores" ; width = 20 ; e={$_.numberofcores}},
@{n="Size of Cache L1" ; width = 20 ; e={$_.l1cachesize}},
@{n="Size of Cache L2" ; width = 20 ; e={$_.l2cachesize}},
@{n="Size of Cache L3" ; width = 20 ; e={$_.l3cachesize}}

get-ciminstance win32_physicalmemory | 
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Vendor" ; width = 20 ; e={$_.partnumber}},
@{n="Description" ; width = 20 ; e={$_.description}},
@{n="Size" ; width = 20 ; e={$_.capacity}},
@{n="Bank Slot" ; width = 20 ; e={$_.banklabel}},
@{n="Capacity" ; width = 20 ; e={$_.capacity}}

get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | 
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Index" ; width = 20 ; e={$_.index}},
@{n="IPAddress" ; width = 20 ; e={$_.ipaddress}},
@{n="IPSubnet" ; width = 20 ; e={$_.ipsubnet}},
@{n="DNSDomain" ; width = 20 ; e={$_.DNSDomain}},
@{n="DNSServer" ; width = 20 ; e={$_.DNSServerSearchOrder}}

get-ciminstance win32_videocontroller | 
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Vendor" ; width = 20 ; e={$_.name}},
@{n="Horizontal Resolution" ; width = 20 ; e={$_.currenthorizontalresolution}},
@{n="Vertical Resolution" ; width = 20 ; e={$_.currentverticalresolution}}


