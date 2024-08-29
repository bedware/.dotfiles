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
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "npx cypress open"'
                tmux split-window -t 2 -v -d 'pwsh -NoExit -wd ~/software/work/nadeks/ru.nadeks.aria.backoffice -Command "gulp watch"'
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "vi /cypress/e2e/first.cy.js"'
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

    ##############
    # running windows

    # session - settings
    $ubuntuSettingsPath = "~/.dotfiles"
    $ubuntuName = "settings"
    tmux new-session -s $ubuntuName -n dotfiles -d -c $ubuntuSettingsPath
    tmux new-window -t $ubuntuName -n nvim -d -c $ubuntuSettingsPath

    # session - nadex
    $projectPath = "~/software/work/nadeks"
    tmux new-session -s $company -n code -d -c $projectPath
    tmux new-window -t $company -n git -d -c $projectPath
    tmux new-window -t $company -n db -d -c $projectPath
    tmux new-window -t $company -n live -d -c $projectPath
    tmux new-window -t $company -n other -d -c $projectPath

    Start-Sleep -Milliseconds 5000;

    ##############
    # sending keys
    # session - settings
    tmux send-keys -t $ubuntuName`:dotfiles -- "vi ." C-m
    tmux send-keys -t $ubuntuName`:nvim -- "vi ." C-m

    # session - nadex
    tmux send-keys -t $company`:code -- "vi ." C-m
    tmux send-keys -t $company`:git -- "git status" C-m
    tmux send-keys -t $company`:db -- '$env:LESS = "-S +g"; usql mysql://root:secret@localhost/test1' C-m

    # tmux send-keys -t $company`:live -- "start-working-session live" C-m
    tmux send-keys -t $company`:other -- "htop" C-m

    tmux attach
}

