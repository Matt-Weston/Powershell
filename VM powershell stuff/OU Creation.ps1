$locations = "Texas","New York";
$accountGroups = "Accounts","Computers","Groups";
$departments = "Finance & Accounting","Human Resources","Sales","Marketing",
"Engineering","Consulting","IT","Planning","Contracts","Purchasing";
$computerTypes = "Servers","Desktops","Mobile Devices"
if (Test-Path -Path 'D:\Powershell Stuff\VM powershell stuff\FirstLastEurope.csv') {
  $Names = Import-CSV 'D:\Powershell Stuff\VM powershell stuff\FirstLastEurope.csv'
} else {
  $Names = Import-CSV ./Desktop/Powershell/FirstLastEurope.csv
}

$firstnames = $Names.Firstname
$lastnames = $Names.Lastname

Function Create_User {
  $User = new-Object PsObject
  $User | add-member -NotePropertyName Department -NotePropertyValue ($Departments = $departments | random)
  $User | add-member -NotePropertyName FirstName -NotePropertyValue ($firstname = $firstnames | random)
  $User | add-member -NotePropertyName LastName -NotePropertyValue ($lastname = $lastnames | random)
  $User | add-member -NotePropertyName Password -NotePropertyValue ($Password = "Password1!")
  return $User
}
#Creates 1000 users using Create_User Function
$users = @()
for ($i=0; $i -lt 1000; $i++) {
  $user = Create_User
  $users += $user
}

foreach ($location in $locations) { #Create Location base folder
  $RootDomain = (Get-ADForest | select -ExpandProperty RootDomain).split(".")
  $path = "DC=" + $RootDomain[0] + ",DC=" + $RootDomain[1]
  $locationName = $location + " Location"
  write-host -foreground 'green' 'New-ADOrganizationalUnit -Name ' $locationName ' -Path ' $Path
  foreach ($accountGroup in $accountGroups) { #Create the groups within each Location
    $accountGroupPath = "DC=" + $locationName + "," + $path;
    write-host -foreground 'red' 'New-ADOrganizationalUnit -Name ' $accountGroup ' -Path ' $accountGroupPath
    if ($accountGroup -eq "Accounts") {
      #Create separate groups within accounts folder
      foreach ($department in $departments) {
        $departmentPath = "DC=" + $department + "," + $accountGroupPath;
        write-host 'New-ADOrganizationalUnit -Name ' $department ' -Path ' $departmentPath
      }
    }
    elseif ($accountGroup -eq "Computers") {
      #Create separate groups within computers folder
      foreach ($computerType in $computerTypes) {
        $computerTypePath = "DC=" + $computerType + "," + $accountGroupPath;
        write-host 'New-ADOrganizationalUnit -Name ' $computerType ' -Path ' $computerTypePath
      }
    }
    elseif ($accountGroup -eq "Groups") {
      #Create separate groups within groups folder
    }
  }
}
