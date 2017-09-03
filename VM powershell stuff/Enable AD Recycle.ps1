#Enabling AD Recycle Bin
Enable-ADOptionalFeature –Identity ‘CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=POOP,DC=LOCAL’ –Scope ForestOrConfigurationSet –Target 'Poop.local'
