function testEmptyProfile {
    $activity = "empty"
    $testRounds = 10
    $i = 100 / $testRounds
    $totalTimeMs = 0
    1..$testRounds | ForEach-Object {
        Write-Progress -Id 1 -Activity $activity -PercentComplete ($_ * $i)
        $totalTimeMs += (Measure-Command {
            pwsh -noprofile -command 1
        }).TotalMilliseconds 
    }
    Write-Progress -id 1 -Activity $activity -Completed
    Write-Host ($totalTimeMs/$testRounds)
}


function testMyProfile {
    $activity = "myprofile"
    $testRounds = 10
    $i = 100 / $testRounds
    $totalTimeMs = 0
    1..$testRounds | ForEach-Object {
        Write-Progress -Id 1 -Activity $activity -PercentComplete ($_ * $i)
        $totalTimeMs += (Measure-Command {
            pwsh -command 1
        }).TotalMilliseconds
    }
    Write-Progress -id 1 -activity $activity -Completed
    Write-Host ($totalTimeMs/$testRounds)
}

testEmptyProfile
testMyProfile
