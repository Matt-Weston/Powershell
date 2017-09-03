Function InitialStartup {
  <#
  #  Configures Computer Name
  #  Configures DNS to point towards itself for lookups
  #  Computer Name change requires reboot
  #>
  $DNS = "127.0.0.1", "8.8.8.8"
  $IPAddress = "192.168.1.220"
  $Mask = 24
  $Gateway = "192.168.1.1"
  Rename-Computer "DC1"
  $InterfaceAlias = Get-NetIPAddress | ? {$_.AddressFamily -eq "IPv4" -and $_.InterfaceAlias -notLike "*Host-Only*" -and $_.ipaddress -notlike "127.0.0.1"} | Select -ExpandProperty InterfaceAlias
  New-NetIpAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $Mask -DefaultGateway $Gateway
  Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DNS
  Restart-Computer
}
Function SetupADDS {
  <#
  #  Creates a Domain from scratch using $DomainName Forest
  #  Configures Recovery Password as $SafeModePwd
  #  Configuring ADDS requires reboot
  #>
  $SafeModePwd = "Testing123!"
  $DomainName = "Mattweston.me"
  Import-Module ServerManager
  Add-WindowsFeature AD-Domain-Services -IncludeManagementTools
  Import-Module ADDSDeployment
  $SafeModePwd = ConvertTo-SecureString $SafeModePwd -AsPlainText -Force
  Install-ADDSForest -DomainName $DomainName -SafeModeAdministratorPassword $SafeModePwd -force
}
Function SetupDHCP {
  <#
  # Configures DHCP with DHCP ranges using DHCPRangeCreation Function
  #>
  Function DHCPRangeCreation($start,$end,$subnet){
    <#
    #  Creates Object for DHCP Ranges
    #>
    $Range = New-Object PSObject
    $Range | Add-Member -NotePropertyName "StartRange" -NotePropertyValue $Start
    $Range | Add-Member -NotePropertyName "EndRange" -NotePropertyValue $End
    $Range | Add-Member -NotePropertyName "SubnetMask" -NotePropertyValue $Subnet
    return $Range
  }
  $ComputerName = $env:computername
  $DNSServerIP = Get-NetIPAddress | ? {$_.AddressFamily -eq "IPv4" -and $_.InterfaceAlias -notLike "*Host-Only*" -and $_.ipaddress -notlike "127.0.0.1"} | select -expandProperty "IpAddress"
  $DHCP_DNSIPS = $DNSServerIP,"8.8.8.8"
  $DHCPRange = DHCPRangeCreation("192.168.1.220")("192.168.1.250")("255.255.255.0")
  Add-WindowsFeature -IncludeManagementTools DHCP
  Import-Module DHCPServer
  Add-DHCPServerv4Scope -Name "DHCP1" -StartRange $DHCPRange.StartRange -EndRange $DHCPRange.EndRange -SubnetMask $DHCPRange.SubnetMask -Description DHCP1
  Set-DHCPServerv4OptionValue -optionID 6 -value $DHCP_DNSIPS
  Set-DHCPServerv4OptionValue -ComputerName DC1.passport.my -ScopeID 192.168.1.0 -DNSServer 192.168.1.200 -router 192.168.1.1
  Add-DHCPServerInDC $ComputerName $DNSServerIP
  Set-ItemProperty -Path Registry::HKey_Local_Machine\Software\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
  Restart-Computer
}

Function SetupDNS {
  <#
  #  Configures DNS
  #  Creates Reverse Lookup Zone for 192.168.1.0/24 to replicate over the Forest.
  #  Applies DNS forwarder to 8.8.8.8 (Google DNS)
  #  Applies DNS Scavenging 30 days
  #>
  Add-WindowsFeature DNS -IncludeManagementTools
  Import-Module DNSServer
  Add-DNSServerPrimaryZone -DynamicUpdate Secure -NetworkID '192.168.1.0/24' -ReplicationScope 'Forest'
  Set-DNSServerForwarder -IPAddress "8.8.8.8"
  Set-DNSServerScavenging -RefreshInterval 30.00:00:00
  Restart-Computer
}

Function Install-SCCM {
  <#
  #>
  #Downloads#
  # 1 Windows ADK Win 10 1703
  (New-Object System.Net.WebClient).DownloadFile("https://go.microsoft.com/fwlink/p/?LinkId=845542","$HOME\desktop\Win ADK 1703.exe")
  # 2 Create Container for System Management
  $Root = (Get-ADRootDSE).defaultNamingContext
  $OU = New-AdObject -Type Container -Name "System Management" -Path "CN=System,$Root" -Passthru
  $Acl = Get-Acl "ad:CN=System Management,CN=System,$Root"
  $Computer = Get-ADComputer $env:ComputerName
  $SID = [System.Security.Principal.SecurityIdentifier] $Computer.SID
  $adRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
  $type = [System.Security.AccessControl.AccessControlType] "Allow"
  $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
  $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $SID,$adRights,$type,$inheritanceType
  $Acl.AddAccessRule($ace) 
  Set-Acl -Aclobject $Acl "ad:CN=System Management,CN=System,$Root"
  # 3 Extend Schema for SCCM
  & 'D:\SC_Configmgr_SCEP_1702 (1).exe'
  do {$found = Test-Path 'C:\SC_Configmgr_SCEP_1702\SMSSETUP\BIN\X64\extadsch.exe'; Sleep 2}
  Until ($found = "True") {
    Start-Process -FilePath 'C:\SC_Configmgr_SCEP_1702\SMSSETUP\BIN\X64\extadsch.exe'
  }
  # 4 Install Pre-Req Features
  Install-WindowsFeature Web-Windows-Auth
  Install-WindowsFeature Web-ISAPI-Ext
  Install-WindowsFeature Web-Metabase
  Install-WindowsFeature Web-WMI
  Install-WindowsFeature BITS
  Install-WindowsFeature RDC
  Install-WindowsFeature NET-Framework-Features
  Install-WindowsFeature Web-Asp-Net
  Install-WindowsFeature Web-Asp-Net45
  Install-WindowsFeature NET-HTTP-Activation
  Install-WindowsFeature NET-Non-HTTP-Activation
}

















