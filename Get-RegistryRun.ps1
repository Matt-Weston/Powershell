Function Get-RegistryRun {

	$Hash_HKLM_Run = @{}
	$Hash_HKLM_RunOnce = @{}
	$Hash_HKLM_WOW6432Node_Run = @{}
	$Hash_HKLM_WOW6432Node_RunOnce = @{}
	$Hash_HKCU_Run = @{}
	$Hash_HKCU_RunOnce = @{}
	
	#HKLM Run
	$HKLM_Run = Get-Item HKLM:\Software\Microsoft\Windows\CurrentVersion\Run | select -ExpandProperty Property
	foreach ($items in $HKLM_Run) {
		$Hash_HKLM_Run[$items] = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Run).$items
	}
	#HKLM RunOnce
	$HKLM_RunOnce = Get-Item HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce | select -ExpandProperty Property
	foreach ($items in $HKLM_RunOnce) {
		$Hash_HKLM_RunOnce[$items] = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce).$items
	}
	#HKLM Wow6432Node Run
	$HKLM_WOW6432Node_Run = Get-Item HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run | select -ExpandProperty Property
	foreach ($items in $HKLM_WOW6432Node_Run) {
		$Hash_HKLM_WOW6432Node_Run[$items] = (Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run).$items
	}
	#HKLM Wow6432Node RunOnce
	$HKLM_WOW6432Node_RunOnce = Get-Item HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce | select -ExpandProperty Property
	foreach ($items in $HKLM_WOW6432Node_RunOnce) {
		$Hash_HKLM_WOW6432Node_RunOnce[$items] = (Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce).$items
	}
	#HKCU Run
	$HKCU_Run = Get-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Run | select -ExpandProperty Property
	foreach ($items in $HKCU_Run) {
		$Hash_HKCU_Run[$items] = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run).$items
	}
	#HKCU RunOnce
	$HKCU_RunOnce = Get-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce | select -ExpandProperty Property
	foreach ($items in $HKCU_RunOnce) {
		$Hash_HKCU_RunOnce[$items] = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce).$items
	}
	Write-host -ForegroundColor Green "Hash_HKLM_Run"
	$Hash_HKLM_Run
	Write-host -ForegroundColor Green "Hash_HKLM_RunOnce"
	$Hash_HKLM_RunOnce
	Write-host -ForegroundColor Green "Hash_HKLM_WOW6432Node_Run"
	$Hash_HKLM_WOW6432Node_Run 
	Write-host -ForegroundColor Green "Hash_HKLM_WOW6432Node_RunOnce"
	$Hash_HKLM_WOW6432Node_RunOnce 
	Write-host -ForegroundColor Green "Hash_HKCU_Run"
	$Hash_HKCU_Run
	Write-host -ForegroundColor Green "Hash_HKCU_RunOnce"
	$Hash_HKCU_RunOnce
}