; Git
::ga::git add .
::gA::git add --all
::gb::git branch -vvv
::gco::git checkout
::gcob::git checkout -b
::gcom::git checkout master
::gcm::git commit -m
::gca::git commit --amend --no-edit
::gdif::git diff --color | less -R
::gdifs::git diff --staged --color | less -R
::glf::git log --follow --patch
::glo::git log -n20 --oneline
:*:gpull::git pull
:*:gpush::git push
::gpsup::git push --set-upstream origin $(git branch --show-current)
::gsm::git submodule
::gst::git status

; Docker/Podman
::dcd::podman compose down
::dcu::podman compose up -d
:*:dpsa::podman ps -a
::dps::podman ps
::drm::podman container rm -f
:*:dcstart::podman container start
:*:dcstop::podman container stop
::dvl::podman volume ls
::dnl::podman network ls
::dnc::podman network create --subnet=192.168.42.0/24 network_name

; Tmux
:*:;ta::tmux attach
:*:;ts::tmux-sessionizer
:*:;tk::tmux kill-server
:*:;tn::tmux new -s

; ShellGpt
; :*:;sm::sgpt @'{Enter}
; :*:;ss::sgpt ''{Left}

; Maven
:*:mpack::mvn package
:*:mcp::mvn clean package
:*:mgen::mvn archetype:generate

; Utils
:*:;waituntil::wget localhost:7777 --quiet --tries 20 --waitretry 1 --retry-connrefused -O /dev/null
:*:;compressvideo::ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
:*:;ul::unzip -l

; SSH
:*:;sshgened::ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "Comment"
:*:;sshgenrsa::ssh-keygen -t rsa -b 4096 -C "Comment"

; Text
:*:;@::dmitry.surin@gmail.com
:*:;me::Dmitry Surin
:*:;rdp::dDBI3isESvoP

; Windows
:*:;lock::rundll32.exe user32.dll,LockWorkStation
:*:;env::rundll32.exe sysdm.cpl,EditEnvironmentVariables

