function OnViModeChange {
    if ($args[0] -eq "Command") {
        # Set the cursor to a non blinking block.
        Write-Host -NoNewLine "`e[2 q"
    } else {
        # Set the cursor to a non blinking line.
        Write-Host -NoNewLine "`e[6 q"
    }
}

Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

