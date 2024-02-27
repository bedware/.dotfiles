$newPodmanPort = podman.exe system connection list | Select-String ':(\d+)/' | ForEach-Object { $_.Matches.Groups[1].Value } | Select-Object -First 1
podman system connection remove podman-machine-default-root
podman system connection add --default --identity ~/.ssh/podman-machine-default podman-machine-default-root "ssh://root@127.0.0.1:$newPodmanPort/run/podman/podman.sock"

