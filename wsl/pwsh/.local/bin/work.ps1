$company = "nadex"

tmux list-sessions | ForEach-Object {
    if ($_ -match "^$company") {
        Write-Output $_
        tmux attach -t $company
        exit
    }
}

tmux kill-server

# settings
$settings_path = "~/.dotfiles"

tmux new-session -d -s settings -n nvim -c exec pwsh -Interactive -NoExit -wd "$settings_path/wsl/nvim/.config/nvim"
tmux new-window -t settings -n .dotfiles -c exec pwsh -Interactive -NoExit -wd $settings_path

# nadex
$project_path = "~/work/nadex"

tmux new-session -d -s $company -n code -c exec pwsh -Interactive -NoExit -wd $project_path
tmux new-window -t $company -n git -c exec pwsh -Interactive -NoExit -wd $project_path
tmux new-window -t $company -n db -c exec pwsh -Interactive -NoExit -wd $project_path
tmux new-window -t $company -n run -c exec pwsh -Interactive -NoExit -wd "$project_path/ru.nadeks.aria.ganz"
tmux new-window -t $company -n other -c exec pwsh -Interactive -NoExit -wd $project_path
tmux attach -t $company -c $project_path
