$testRounds = 10
$i = 100 / $testRounds
$p = 0

function testEmptyProfile {
    1..$testRounds | ForEach-Object {
        Write-Progress -Id 1 -Activity 'pwsh' -PercentComplete ($_ * $i)
        $p += (Measure-Command {
            pwsh -noprofile -command 1
        }).TotalMilliseconds 
    }
    Write-Progress -id 1 -Activity 'profile' -Completed
    $p = $p/$testRounds
    $p
}

function testMyProfile {
    $a = 0
    1..$testRounds | ForEach-Object {
        Write-Progress -Id 1 -Activity 'profile' -PercentComplete ($_ * $i)
        $a += (Measure-Command {
            pwsh -command 1
        }).TotalMilliseconds
    }
    Write-Progress -id 1 -activity 'profile' -Completed
    $a/$testRounds - $p
}

testEmptyProfile
testMyProfile
