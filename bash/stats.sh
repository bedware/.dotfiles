#!/bin/bash

set -e

file_pattern=$1

function main {
	for rev in `revisions`; do
		echo "`number_of_lines` `commit_description`"
	done
}

function revisions {
	git rev-list --reverse HEAD -- ~/.dotfiles
}

function commit_description {
	git log --oneline -1 $rev
}

function number_of_lines {
	file_in_rev=$(git ls-tree -r $rev -- ~/.dotfiles |
	grep "$file_pattern" | 
	awk '{print $3}')
	if [[ -z $file_in_rev ]] ; then
		echo 0
	else
		echo $file_in_rev |
		xargs git show |
		wc -l;
	fi
}

main

