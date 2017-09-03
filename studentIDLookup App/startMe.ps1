#Required to load the XAML form and create the PowerShell Variables

$path = $PSScriptRoot
$pathLoadDialog = $path + "\LoadDialog.ps1"
$pathForm = $path + "\form.xaml"
$pathLoadingFunctions = $path + "\Loading Functions.ps1"

& $pathLoadDialog -XamlPath ($pathForm)
# . Path - Loads up a Library for the script "dot sourcing"
# . $pathLoadingFunctions

$pathFakeDatabase = $path + "\FakeDatabaseLookup.txt"
 

#EVENT Handler


$Day.Content = (Get-Date).Dayofweek

$searchButton.add_Click({
    if ($radioButton.IsChecked) {
        $Campus = "OLE"
        $studentID = $searchBox.Text
    } elseif ($radioButton2.IsChecked){
          $Campus = "MMS"
          $studentID = $searchBox.Text
      }

      <###############################Should be function. But it wasn't working when it was there#######>
      $searchList = new-object System.Collections.Arraylist
             $foundList = new-object System.Collections.Arraylist
             $dbList = gc -Path $pathFakeDatabase

             if ($studentID.contains(",")) {
                $a = $studentID.split(",")
                foreach ($b in $a) {
                    [void]$searchList.add($b)
                }
             } else {
                [void]$searchList.add($studentID)
             }
             for ($i=0; $i -lt $searchList.count; $i++) { #foreach SearchList
                for ($j=0; $j -lt $dbList.count; $j++) { #foreach DbItems
                    if ($searchList[$i] -eq $dbList[$j].split(";")[0]) {
                        [void]$foundList.add($dbList[$j])
                    }
                  }
             }
      <#################################################################################################>

      $result = $foundList

      #$resultSplit = $result.split(";")
      $objects = @()
      for ($j=0; $j -lt $result.count; $j++) { #Rows
        if ($foundList.count -gt 1) {
        $resultSplit = $result[$j].split(";")
        } else {
        $resultSplit = $result.split(";")
        }
          $objects += @([pscustomobject]@{
                A=$resultSplit[1];
                B=$resultSplit[2];
                C=$resultSplit[3];
                D=$resultSplit[4];
                E=$resultSplit[5];
                F=$resultSplit[6];
                G=$resultSplit[7];
                H=$resultSplit[8];
                I=$resultSplit[9];
                J=$resultSplit[10];
                K=$resultSplit[11];})
      }
      $dataGrid1.ItemsSource = $objects;
})

<#
$MyButton2.add_Click({
& "C:\Users\Matt\Desktop\RSBotPS\Bolts.ps1"
})#>

#Launch the window
$xamGUI.Topmost = $true;
$xamGUI.ShowDialog() | out-null


<#
$dir = dir c:\users | select Name
$a = ($dir.Name)
$MyLabel.Content =  $a -join "`n"
#>
