; <arg> - optional argument
; !<arg> - required argument 

; Docker
::dps::podman ps ; <container> show containers table
:*:dpsa::podman ps -a ; <container> show containers table

; Docker Compose
:*:dcu::docker-compose up -d ; <container> up containers detached
:*:dcd::docker-compose down ; <container> down containers

; Git
:*:gst::git status ; !<file>
:*:gsm::git submodule ; !<command>
::glf::git log --follow --patch ; !<file> history as patches
::gdiff::git diff --color | less -R ; <file> view current diff (WorkTree to Staged)
::gdifs::git diff --staged --color | less -R ; <file> view current diff (Staged to Commited)

; Tmux
:*:tmi::tmux-init ; <new_session_name> create preinitialized workplace
:*:tma::tmux attach ; <session_name> connect to session
:*:tmn::tmux new -s ; <session_name> new session
:*:tmk::tmux kill-server ; kill all sessions

