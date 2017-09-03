 function studentLookup {
       param([string]$Campus = "",
       [string[]]$studentID = "")
       $searchList = new-object System.Collections.Arraylist
       $foundList = new-object System.Collections.Arraylist
       $dbList = gc -Path C:\users\matt\desktop\PowershellForm\FakeDatabaseLookup.txt

       if ($studentID.contains(",")) {
          $a = $studentID.split(",")
          foreach ($b in $a) {
              $searchList.add($b) >> null
          }
       } else {
          $searchList.add($studentID) >> null
       }
       for ($i=0; $i -lt $searchList.count; $i++) { #foreach SearchList
          for ($j=0; $j -lt $dbList.count; $j++) { #foreach DbItems
              if ($searchList[$i] -eq $dbList[$j].split(";")[0]) {
                  $foundList.add($dbList[$j]) >> null
              }
            }
       }
       return [String[]]$foundList
       }