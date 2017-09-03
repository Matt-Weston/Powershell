#Required to load the XAML form and create the PowerShell Variables

$path = $PSScriptRoot
$pathLoadDialog = $path + "\LoadDialog.ps1"
$pathForm = $path + "\Login Form.xaml"
$pathLoadingFunctions = $path + "\functions.ps1"

& $pathLoadDialog -XamlPath ($pathForm)
# . Path - Loads up a Library for the script using dot sourcing
. $pathLoadingFunctions

#Extra stuff
$domain = (Get-IniContent config.ini).domain.Keys
$username.Text = "$domain/username"

$ErrorMessage = ""


#EVENT Handler

$Window.add_KeyDown{
param
(
  [Parameter(Mandatory)][Object]$sender,
  [Parameter(Mandatory)][Windows.Input.KeyEventArgs]$e
)
	if($e.Key -eq "Esc")
	{
		$xamGUI.close();
	}
	if($e.Key -eq "return")
	{
		if ($username.text -ne "" -and $password.Password -ne "") {
			$UPN = $domain.split(".")[0] + "/" + $username.text
			$secpasswd = ConvertTo-SecureString $password.Password -AsPlainText -Force
			$mycreds = New-Object System.Management.Automation.PSCredential ($UPN, $secpasswd)
			try {
				Start-Process -FilePath cmd.exe /c -Credential $mycreds -WindowStyle hidden -ErrorAction Stop
			}
			catch {
				$ErrorMessage = $_.Exception.Message
			}
			if ($ErrorMessage.Contains("The user name or password")) {
				$btnLogin.Content = "incorrect"
			} else {
				# Check to see if member of XXXXXXXX group
				$xamGUI.close();
				& .\LoadDialog.ps1 -XamlPath '.\helpdesk form.xaml'
				$xamGUI.ShowDialog() | out-null
			}
		}
	}    
}


$lock.Source = $path +  "/images/lock icon.png"
$person.Source = $path +  "/images/person.png"
$userLogin.Source = $path + "/images/User Login.png"

$username.Add_GotFocus({
	$username.Text = "";
});

$btnLogin.add_Click({
	if ($username.text -ne "" -and $password.Password -ne "") {
		$UPN = $domain.split(".")[0] + "/" + $username.text
		$secpasswd = ConvertTo-SecureString $password.Password -AsPlainText -Force
		$mycreds = New-Object System.Management.Automation.PSCredential ($UPN, $secpasswd)
		try {
			Start-Process -FilePath cmd.exe /c -Credential $mycreds -WindowStyle hidden -ErrorAction Stop
		}
		catch {
			$ErrorMessage = $_.Exception.Message
		}
		if ($ErrorMessage.Contains("The user name or password")) {
			$btnLogin.Content = "incorrect"
			$xamGUI.close();
			& .\LoadDialog.ps1 -XamlPath '.\helpdesk form.xaml'
			$xamGUI.ShowDialog() | out-null
		} else {
			# Check to see if member of XXXXXXXX group
			$xamGUI.close();
			& .\LoadDialog.ps1 -XamlPath '.\helpdesk form.xaml'
			$xamGUI.ShowDialog() | out-null
		}
	}
});

#Launch the window
$xamGUI.Topmost = $true;
$xamGUI.ShowDialog() | out-null