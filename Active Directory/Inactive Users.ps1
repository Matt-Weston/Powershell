<#
 #
 # Look through all users in AD, looking at LastLogonTimeStamp
 # Then echoing the user's name and the days since last seen.
 #
 #>

$users = Get-ADUser -Filter * -Properties LastLogonTimeStamp
foreach ($user in $users) {
	$user.Name
	$lastSeen = [datetime]::FromFileTime($user.LastLogonTimeStamp)
	$today = [datetime]::Today
	$days = ($today - $lastSeen).days
	$days.toString() + " days since last seen"
}