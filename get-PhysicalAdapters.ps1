<#
.SYNOPSIS
Get-PhysicalAdapters Get Physical Network adapters.
.DESCRIPTION
Display physical adapters from the win32_networkadapter class.
.PARAMETER computername
The computer name to check. 
.EXAMPLE
PS C:\Users\Ajay\Documents\scripts> .\get-PhysicalAdapters.ps1 -computername localhost
#>

[CmdletBinding()]
param (
  [Parameter(Mandatory=$True,HelpMessage="Enter a computername to query")]
  [Alias('hostname')]   
  [string]$computername
)

Write-Verbose "Getting physical network adapters from $computername"

Get-WmiObject win32_networkadapter -ComputerName $computername |
where {$_.physicaladapter} |
select MACAddress,Adaptertype,DeviceID,Name,Speed

Write-Verbose "Script Finished."