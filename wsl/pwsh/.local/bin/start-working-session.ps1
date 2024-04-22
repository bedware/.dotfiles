function Select-TmuxWindowByName {
    param ([string]$WindowName)
    $windowIndex = tmux list-windows -F '#{window_index} #{window_name}' | Where-Object { $_ -match $WindowName } | ForEach-Object { $_.Split(' ')[0] }
    tmux select-window -t $windowIndex
}

function IdempotentScript($name, $script) {
    Select-TmuxWindowByName($name)

    $windowIndex = tmux display-message -p "#{window_index}"
    $windowName = tmux display-message -p "#{window_name}"

    tmux rename-window 'temp'
    tmux move-window -s $windowIndex -t 0
    tmux new-window -n $windowName

    Write-Host "Run before script: $windowName : $windowIndex"
    . $script
    Write-Host "Run after script"

    tmux kill-pane -t 1
    sleep 2
    tmux kill-window -t 0
    sleep 2
}

if ($args[0] -is [string]) {
    switch ($args[0]) {
        "live" {
            #  __________ _______________ 
            # |          |               |
            # |   test   |  cypress      |
            # | scenario |_______________|
            # |          |               |
            # |          |  gulp watch   |
            # |__________|_______________|
            IdempotentScript "live" {
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\work\nadex" -Command "npx cypress open"'
                tmux split-window -t 2 -v -d 'pwsh -NoExit -wd ~/work/nadex/ru.nadeks.aria.backoffice -Command "gulp watch"'
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\work\nadex/cypress/e2e" -Command "vi first.cy.js"'
            }
        }
        default {
            Write-Host "$($args[0]) is not recognized as a work script"
        }
    }
} else {
    $company = "nadeks"
    tmux list-sessions | ForEach-Object {
        if ($_ -match "^$company") {
            Write-Output $_
            tmux attach -t $company
            exit
        }
    }
    # tmux kill-server

    $ubuntuHome = "~"
    $ubuntuSettingsPath = "$ubuntuHome/.dotfiles"
    $ubuntuName = "settings_ubuntu"
    tmux new-session -s $ubuntuName -n dotfiles -d "pwsh -NoExit -wd $ubuntuSettingsPath -Command vi"
    tmux new-window -t $ubuntuName -n nvim -d "pwsh -NoExit -wd $ubuntuSettingsPath/wsl/nvim/.config/nvim -Command vi"

    $windowsHome = "C:\Users\dmitr"
    $windowsSettingsPath = "$windowsHome/.dotfiles"
    $windowsName = "settings_windows"
    tmux new-session -s $windowsName -n dotfiles -d "wpwsh -NoExit -wd $windowsSettingsPath -Command vi"
    tmux new-window -t $windowsName -n nvim -d "wpwsh -NoExit -wd $windowsSettingsPath/wsl/nvim/.config/nvim -Command vi"
    tmux new-window -t $windowsName -n ahk -d "wpwsh -NoExit -wd $windowsSettingsPath/win/ahk -Command vi"

    $projectPath = "~/work/nadex"
    tmux new-session -s $company -n code -d "pwsh -NoExit -wd $projectPath -Command vi"
    tmux new-window -t $company -n git -d "pwsh -NoExit -wd $projectPath -Command 'git status'"
    tmux new-window -t $company -n db -d "pwsh -NoExit -wd $projectPath -Command 'usql mysql://root:secret@localhost/test1'"
    tmux new-window -t $company -n live -d "pwsh -NoExit -wd $projectPath -Command 'start-working-session live'"
    tmux new-window -t $company -n other -d "pwsh -NoExit -wd $projectPath -Command htop"

    tmux attach
}

