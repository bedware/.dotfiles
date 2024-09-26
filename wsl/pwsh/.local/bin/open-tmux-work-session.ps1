function Select-TmuxWindowByName([string]$WindowName) {
    $windowIndex = tmux list-windows -F '#{window_index} #{window_name}' | Where-Object { $_ -match $WindowName } | ForEach-Object { $_.Split(' ')[0] }
    tmux select-window -t $windowIndex
}

function Run-ScriptIdempotently($name, $script) {
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

function Check-AttachOrCreate($name) {
    tmux list-sessions | ForEach-Object {
        if ($_ -match "^$name") {
            Write-Host "Session exists. Attaching to $_"
            tmux attach -t $name
            exit
        }
    }
}

if ($args[0] -is [string]) {
    switch ($args[0]) {
        "settings" {
            $ubuntuSettingsPath = "~/.dotfiles"
            $sessionName = "settings"

            Check-AttachOrCreate($company)

            tmux new-session -s $sessionName -n dotfiles -d -c $ubuntuSettingsPath
            tmux new-window -t $sessionName -n nvim -d -c $ubuntuSettingsPath

            Start-Sleep -Milliseconds 3000;

            tmux send-keys -t $sessionName`:dotfiles -- "vi ." C-m
            tmux send-keys -t $sessionName`:nvim -- "vi ." C-m

            tmux attach
        }
        "nadeks" {
            $company = "nadeks"
            $projectPath = "~/software/work/nadeks"

            Check-AttachOrCreate($company)

            tmux new-session -s $company -n code -d -c $projectPath
            tmux new-window -t $company -n git -d -c $projectPath
            tmux new-window -t $company -n db -d -c $projectPath
            tmux new-window -t $company -n live -d -c $projectPath
            tmux new-window -t $company -n other -d -c $projectPath

            Start-Sleep -Milliseconds 5000;

            tmux send-keys -t $company`:code -- "vi ." C-m
            tmux send-keys -t $company`:git -- "git status" C-m
            tmux send-keys -t $company`:db -- '$env:LESS = "-S +g"; usql mysql://root:secret@localhost/test1' C-m
            # tmux send-keys -t $company`:live -- "start-working-session live" C-m
            tmux send-keys -t $company`:other -- "htop" C-m

            tmux attach
        }
        "nadeks-live" {
            #  __________ _______________ 
            # |          |               |
            # |   test   |  cypress      |
            # | scenario |_______________|
            # |          |               |
            # |          |  gulp watch   |
            # |__________|_______________|
            Run-ScriptIdempotently "live" {
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "npx cypress open"'
                tmux split-window -t 2 -v -d 'pwsh -NoExit -wd ~/software/work/nadeks/ru.nadeks.aria.backoffice -Command "gulp watch"'
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "vi /cypress/e2e/first.cy.js"'
            }
        }
        "alfa" {
            $company = "alfabank"
            $projectPath = "~/software/work/alfabank"

            Check-AttachOrCreate($company)

            tmux new-session -s $company -n corp-loyalty-api -d -c $projectPath

            Start-Sleep -Milliseconds 3000;

            tmux send-keys -t $company`:code -- "cd corp-loyalty-api; vi ." C-m

            tmux attach
        }
        default {
            Write-Host "$($args[0]) is not recognized as a work script"
        }
    }
} else {
    Write-Error "Argument is required!"
}

