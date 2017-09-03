$domain = ((Get-AdForest | select domains).Domains).split(".")[0]
$extension = ((Get-AdForest | select domains).Domains).split(".")[1]