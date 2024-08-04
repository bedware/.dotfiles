$sessionName = "windows-session"

if ($args[0] -is [string]) {
    $sessionName = $args[0]
}
Write-Host "Starting session: $sessionName"
tmux set-option -g default-shell '/mnt/c/Program Files/PowerShell/7/pwsh.exe'
tmux new-session -s $sessionName -d
tmux set-option -t $sessionName default-shell '/mnt/c/Program Files/PowerShell/7/pwsh.exe'
tmux set-option -g default-shell '/bin/pwsh'
tmux attach

