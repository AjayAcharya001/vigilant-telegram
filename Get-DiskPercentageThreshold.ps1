<#
.SYNOPSIS
Get-DiskPercentageThreshold retrieves logical disk information from one or
more computers and works out the free space.
.DESCRIPTION
Get-DiskFreeSpace uses WMI to retrieve the Win32_LogicalDisk
instances from one or more computers. It displays each disk's
drive letter, free space, total size, and percentage of free
space.
.PARAMETER computername
The computer name, or names, to query. Default: Localhost.
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation
for values. 3 is a fixed disk, and is the default.
.PARAMETER percentage
The percentage threshold to alert when it is less than a specific amount
Default: .75
.EXAMPLE
Get-DiskPercentageThreshold -computername SERVER-R2 -minimum .75 -drivetype 3
#>


param (
  $computername = 'localhost',
  $minpercentfree = 75,
  $drivetype = 3
)
#Convert minimum percent free
$minpercent = $minpercentfree/100

Get-WmiObject Win32_LogicalDisk -computername $computername  -filter "drivetype=$drivetype" |
where { ($_.Freespace / $_.Size) -lt $percent} |
select -Property DeviceID,Freespace,Size