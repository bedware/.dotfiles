
; Git
::ga::git add .
::gA::git add --all
::gb::git branch -vvv
::gcb::git checkout -b
:*:gcm::git checkout master
:*:gco::git checkout
::g.::git commit
:*:g.m::git commit -m ""{Left}
:*:g.a::git commit --amend --no-edit
:*:gdif::git diff --color | less -R
::gdifs::git diff --staged --color | less -R
::glf::git log --follow --patch
::glo::git log -n10 --oneline
::g>::git push
::g<::git pull
::g<r::git pull --rebase
::gpsup::git push --set-upstream origin $(git branch --show-current)
::gsm::git submodule
::gst::git status

; Docker/Podman
::dc::podman container
::dcd::podman compose down
::dcu::podman compose up -d
::dpa::podman ps -a
::dps::podman ps
::drm::podman container rm -f
::dstart::podman container start
::dstop::podman container stop
::dv::podman volume
::dvl::podman volume list

; Tmux
:*:;ta::tmux attach
:*:;ti::tmux-init
:*:;tk::tmux kill-server
:*:;tn::tmux new -s

; ShellGpt
:*:;sm::sgpt @'{Enter}
:*:;ss::sgpt ''{Left}

; Maven
::mp::mvn package
::mcp::mvn clean package
::mg::mvn archetype:generate

; Text
:*:clh::curl localhost:

; Text
:*:;@::dmitry.surin@gmail.com
:*:;me::Dmitry Surin

