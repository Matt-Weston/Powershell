Function Get-LocalAdmins {
	$admins = net localgroup administrators
	$admins[6..($admins.count-3)]
}