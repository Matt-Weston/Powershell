Function Get-NewFilesDay {
	#Returns files created within the last day in the current directory.
	$path = "C:\Users" #example
	gci -Path $path -recurse | ? { $_.CreationTime -gt ((Get-Date).AddDays(-1))} | select -ExpandProperty Name | Out-File ($env:HOMEDRIVE + $env:HOMEPATH + "\Desktop\test.txt")
}