# Sourced from ~/.zshrc (install.sh adds the line). Defines shared + zsh aliases.
() {
  local dir=${${(%):-%x}:A:h} line name cmd
  while IFS= read -r line || [[ -n $line ]]; do
    [[ $line == [[:space:]]#\#* || $line != *=* ]] && continue
    name=${${line%%=*}//[[:space:]]/}
    cmd=${line#*=}
    cmd=${cmd##[[:space:]]#}
    alias -- "$name=$cmd"
  done < "$dir/aliases"
  source "$dir/aliases.zsh"
}
