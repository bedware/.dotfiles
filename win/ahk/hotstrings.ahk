; <arg> - optional argument
; !<arg> - required argument 

; Docker
::dps::podman ps ; <container> show containers table
::dpsa::podman ps -a ; <container> show containers table

; Docker Compose
::dcu::docker-compose up -d ; <container> up containers detached
::dcd::docker-compose down ; <container> down containers

; Git
::gst::git status ; <file>
::glf::git log --follow --patch ; !<file> history as patches
::gdiff::git diff --color | less -R ; <file> view current diff (WorkTree to Staged)
::gdifs::git diff --staged --color | less -R ; <file> view current diff (Staged to Commited)

; Tmux
::ti::tmux-init ; <new_session_name> create preinitialized workplace
::ta::tmux attach ; <session_name> connect to session
::tn::tmux new -s ; <session_name> new session
::tk::tmux kill-server ; kill all sessions

