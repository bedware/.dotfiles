; <arg> - optional argument
; !<arg> - required argument 

; Docker/Podman
::dps::docker ps ; <container> show containers table
::dpsa::docker ps -a ; <container> show containers table
::dvls::docker volume list ; <container> show containers table
::dcstart::docker container start ; <container> up containers detached
::dcstop::docker container stop ; <container> up containers detached
::dcrm::docker container rm -f ; <container> up containers detached
::dcup::docker compose up -d ; <container> up containers detached
::dcdown::docker compose down ; <container> down containers

; Git
::gst::git status ; !<file>
::gbr::git branch -vvv
::gsm::git submodule ; !<command>
::gco::git checkout ; !<command>
::gcb::git checkout -b ; !<branch_name>
::glf::git log --follow --patch ; !<file> history as patches
::glo::git log -n10 --oneline
::gdiff::git diff --color | less -R ; <file> view current diff (WorkTree to Staged)
::gdifs::git diff --staged --color | less -R ; <file> view current diff (Staged to Commited)
::gpsup::git push --set-upstream origin $(git branch --show-current)

; Tmux
::tmi::tmux-init ; <new_session_name> create preinitialized workplace
::tma::tmux attach ; <session_name> connect to session
::tmn::tmux new -s ; <session_name> new session
::tmk::tmux kill-server ; kill all sessions

; ShellGpt
:*:,ss::sgpt ''{Left}
:*:,sm::sgpt @'{Enter}
