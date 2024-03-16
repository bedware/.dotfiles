
; Git
:*:;gst::git status
:*:;gbr::git branch -vvv
:*:;gsm::git submodule
:*:;gco::git checkout
:*:;gcm::git checkout master
:*:;gcb::git checkout -b
:*:;glf::git log --follow --patch
:*:;glo::git log -n10 --oneline
:*:;gdiff::git diff --color | less -R
:*:;gdifs::git diff --staged --color | less -R
:*:;gpsup::git push --set-upstream origin $(git branch --show-current)

; Docker/Podman
:*:;dps::podman ps
:*:;dpa::podman ps -a
:*:;dv::podman volume list
:*:;ds::podman container st
:*:;drm::podman container rm -f
:*:;dcu::podman compose up -d
:*:;dcd::podman compose down

; Tmux
:*:;ti::tmux-init
:*:;ta::tmux attach
:*:;tn::tmux new -s
:*:;tk::tmux kill-server

; ShellGpt
:*:;ss::sgpt ''{Left}
:*:;sm::sgpt @'{Enter}

; Maven
:*:;mg::mvn archetype:generate
:*:;mq::mvn archetype:generate -D"archetypeArtifactId=maven-archetype-quickstart"

; Text
:*:;me::Dmitry Surin
:*:;@::dmitry.surin@gmail.com

