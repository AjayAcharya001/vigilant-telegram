Get-EventLog -LogName security | Where-Object {$_.EventID -eq 4624} | Select-Object -ExpandProperty message | Select-String -Pattern "DWM[\W\w][-2]"

Get-ChildItem -filter *.log -Recurse | Select-String -Pattern "\smofcomp\s" | Format-Table Filename,lineNumber,Line -wrap

Get-ChildItem -filter *.log -Recurse | Select-String -Pattern "\smofcomp\s" | Copy-Item -Destination C:\Users\Ajay\Documents\temp

#Get all the files that have 2 digits in the name in the windows directory
dir C:\Windows | Where-Object {$_.Name -match "\d{2}"}

# To get processes by company name Microsoft
get-process | where {$_.Company -match "^Microsoft"} | select name, ID,Company

#To search a string in a file

Get-Content C:\Users\Ajay\Documents\temp\WindowsUpdate.log | select-string "Installing Updates"

#To match only IPV4 address string

Get-DnsClientcache | Where-Object {$_.Data -match "^\d{1,3}\."}

