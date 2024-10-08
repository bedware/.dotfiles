function Select-TmuxWindowByName([string]$WindowName) {
    $windowIndex = tmux list-windows -F '#{window_index} #{window_name}' | Where-Object { $_ -match $WindowName } | ForEach-Object { $_.Split(' ')[0] }
    tmux select-window -t $windowIndex
}

function Start-ScriptIdempotently($name, $script) {
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

function Test-AttachOrCreate($name) {
    Write-Host "Checking: $name"
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
            $name = "settings"
            $path = "~/.dotfiles"

            Test-AttachOrCreate($name)

            tmux new-session -s $name -n dotfiles -d -c $path
            tmux new-window -t $name -n nvim -d -c "$path/wsl/nvim/.config/nvim".ToString()

            Start-Sleep -Milliseconds 3000;

            tmux send-keys -t $name`:dotfiles -- "vi ." C-m
            tmux send-keys -t $name`:nvim -- "vi ." C-m

            tmux attach
        }
        "quarkus" {
            $name = "quarkus"
            $path = "~/software/personal/quarkus"

            Test-AttachOrCreate($name)

            tmux new-session -s $name -n root -d -c $path
            tmux new-window -t $name -n coffee-shop -d -c "$path/example-coffee-shop".ToString()
            tmux new-window -t $name -n mybang -d -c "$path/mybang".ToString()
            tmux new-window -t $name -n mybang-old -d -c "$path/mybang-master".ToString()

            Start-Sleep -Milliseconds 3000;

            tmux send-keys -t $name`:coffee-shop -- "vi ." C-m
            tmux send-keys -t $name`:mybang-old -- "vi ." C-m
            tmux send-keys -t $name`:mybang -- "vi ." C-m

            tmux attach
        }
        "nadeks" {
            $name = "nadeks"
            $path = "~/software/work/nadeks"

            Test-AttachOrCreate($name)

            tmux new-session -s $name -n code -d -c $path
            tmux new-window -t $name -n git -d -c $path
            tmux new-window -t $name -n db -d -c $path
            tmux new-window -t $name -n live -d -c $path
            tmux new-window -t $name -n other -d -c $path

            Start-Sleep -Milliseconds 5000;

            tmux send-keys -t $name`:code -- "vi ." C-m
            tmux send-keys -t $name`:git -- "git status" C-m
            tmux send-keys -t $name`:db -- '$env:LESS = "-S +g"; usql mysql://root:secret@localhost/test1' C-m
            # tmux send-keys -t $name`:live -- "start-working-session live" C-m
            tmux send-keys -t $name`:other -- "htop" C-m

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
            Start-ScriptIdempotently "live" {
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "npx cypress open"'
                tmux split-window -t 2 -v -d 'pwsh -NoExit -wd ~/software/work/nadeks/ru.nadeks.aria.backoffice -Command "gulp watch"'
                tmux split-window -h -d 'wpwsh -NoExit -wd "C:\Users\dmitr\software\work\nadeks\cypress-ui-tests" -Command "vi /cypress/e2e/first.cy.js"'
            }
        }
        "alfa" {
            $name = "alfabank"
            $path = "~/software/work/alfabank"

            Test-AttachOrCreate($name)

            tmux new-session -s $name -n root -d -c $path
            tmux new-window -t $name -n corp-loyalty-api -d -c "$path/nib/corp-loyalty-api".ToString()

            Start-Sleep -Milliseconds 3000;

            tmux send-keys -t $name`:corp-loyalty-api -- "vi ." C-m

            tmux attach
        }
        default {
            Write-Host "$($args[0]) is not recognized as a work script"
        }
    }
} else {
    Write-Error "Argument is required!"
}

