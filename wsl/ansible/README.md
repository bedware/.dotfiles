Command to run exact tag:
```
ansible-playbook -t dotfiles ./init.yml --ask-become-pass
```
To make output of ansible human readable:
```
$env:ANSIBLE_STDOUT_CALLBACK = 'yaml'
```
