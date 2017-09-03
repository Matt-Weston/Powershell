<#
 #
 # Look through all computers in AD, looking at LastLogonTimeStamp
 # Then echoing the computer's name and the days since last seen.
 #
 #>
 
$computers = Get-ADComputer -Filter * -Properties LastLogonTimeStamp
foreach ($computer in $computers) {
	$computer.Name
	$lastSeen = [datetime]::FromFileTime($computer.LastLogonTimeStamp)
	$today = [datetime]::Today
	$days = ($today - $lastSeen).days
	$days.toString() + " days since last seen"
}