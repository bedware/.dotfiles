set -e

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get install -y build-essential curl git neovim ansible
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get clean autoclean
sudo apt-get autoremove -y

mkdir -p .ssh
cp ssh/id_ed25519 ~/.ssh/
chmod 600 ~/.ssh/*

ansible-playbook init.yml

