Function Get-Startup {

	#returns userinit value
	$userinit = (Get-Item "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\").GetValue("Userinit")
	
	#returns user startup
	$StartupUsers = @{}
	$n = $env:username.Length
	$userDirectory = $env:USERPROFILE -replace ".{$n}$"
	$users = get-childitem -Path $userDirectory | select -ExpandProperty Name
	foreach ($user in $users) {
		$path = $userDirectory + $user + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
		if (Test-Path -Path $path) {
			$startupUsers[$user] = get-childitem -Path $path
		}
	}
	
	#returns system startup
	$sys_Startup = get-childitem -Path ($env:HomeDrive + "\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp") | select -ExpandProperty Name
	
	Write-Host -ForegroundColor Green "user Startup"
	$startupUsers
	Write-Host -ForegroundColor Green "System Startup"
	$sys_Startup
	Write-host -ForegroundColor Green "userinit"
	$userinit.split(",")
}