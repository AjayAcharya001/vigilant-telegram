

DESKTOP-TTRQBD1\Ajay


$configs="C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\Log\20210402_132134\ConfigurationFile.ini"

#foreach($item in (dir $configs "*.ini"))
#{
D:\setup.exe /CONFIGURATIONFILE="$configs" /SQLSYSADMINACCOUNTS="Servername\user" | out-null 
#}


#Install Management Studio
$InstallerSQL = $env:TEMP + “\SSMS-Setup-ENU.exe”; 
Invoke-WebRequest “https://aka.ms/ssmsfullsetup" -OutFile $InstallerSQL; 
start $InstallerSQL /Quiet
Remove-Item $InstallerSQL;

#Get memory information using powershell 
$mem = Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
return ($mem.Sum / 1MB)

#Install SQLPS Module, it might not see the path
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\140\Tools\PowerShell\Modules"
get-module -listavailable
import-module sqlps

# If the computer has less than 8GB of physical memory, allocate 80% of it to SQL Server and leave 20% for the OS and other applications
# If the computer has more than 8GB of physical memory, assign 30% to OS and 70% to SQL Server

Function Get-ComputerMemory {
    $mem = Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    return ($mem.Sum / 1MB);
}

Function Get-SQLMaxMemory { 
    $memtotal = Get-ComputerMemory
    $min_os_mem = 2048 ;
    if ($memtotal -le $min_os_mem) {
        Return $null;
    }
    if ($memtotal -ge 8192) {
        $sql_mem = $memtotal * 0.7
    } else {
        $sql_mem = $memtotal * 0.8 ;
    }
    return [int]$sql_mem ;  
}

Function Set-SQLInstanceMemory {
    param (
        [string]$SQLInstanceName = "localhost", 
        [int]$maxMem = $null, 
        [int]$minMem = 0
    )
 
    if ($minMem -eq 0) {
        $minMem = 1024
    }
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
    $srv = New-Object Microsoft.SQLServer.Management.Smo.Server($SQLInstanceName)
    if ($srv.status) {
        Write-Host "[Running] Setting Maximum Memory to: $($srv.Configuration.MaxServerMemory.RunValue)"
        Write-Host "[Running] Setting Minimum Memory to: 1024"
 
        Write-Host "[New] Setting Maximum Memory to: $maxmem"
        Write-Host "[New] Setting Minimum Memory to: 1024"
        $srv.Configuration.MaxServerMemory.ConfigValue = $maxMem
        $srv.Configuration.MinServerMemory.ConfigValue = 1024   
        $srv.Configuration.Alter()
    }
}

$MSSQLInstance = "localhost"
Set-SQLInstanceMemory $MSSQLInstance (Get-SQLMaxMemory)
