set -e

if [[ ! ansible-playbook ]] ; then

  # Installing ansible
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get install -y build-essential curl git neovim ansible
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get clean autoclean
  sudo apt-get autoremove -y

  # Installing ssh keys
  mkdir -p ~/.ssh
  cp ~/.dotfiles/all/ssh/id_ed25519 ~/.ssh/
  ansible-vault decrypt ~/.ssh/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
  git clone git@github.com:bedware/.ssh.git ~/ssh_tmp
  rm -rf ~/.ssh
  mv ~/ssh_tmp ~/.ssh
  chmod 600 ~/.ssh/*

  # Setting up git
  git config --global user.email "dmitry.surin@gmail.com"
  git config --global user.name "Dmitry Surin"
  cd ~/.dotfiles
  git remote remove origin
  git remote add origin git@github.com:bedware/.dotfiles.git

fi

# Running playbook
cd ~/.dotfiles/wsl/ansible
ansible-playbook init.yml --ask-become-pass
