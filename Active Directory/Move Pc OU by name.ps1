$unassignedPcs = Get-ADComputer -Filter * -SearchBase "OU=Unassigned,DC=Matt,DC=edu"
foreach ($b in $a) {
$c = $b.DNSHostName[0] + "" + $b.DNSHostName[1] + "" + $b.DNSHostName[2];
switch ($c) {
"053" { $b | Move-AdObject -TargetPath "OU=Workstations,OU=McKamy,OU=Campuses,DC=Matt,DC=edu"}
"123" { $b | Move-AdObject -TargetPath "OU=Workstations,OU=Old Settlers,OU=Campuses,DC=Matt,DC=edu" }
default {"Not Found."}
}
}