# fleet-completion.bash — autocomplete for `fleet` (command name, repo and folder).
#
# bash:  source /path/to/fleet-completion.bash
# zsh:   autoload -U +X bashcompinit && bashcompinit
#        source /path/to/fleet-completion.bash
#
# Candidates come from `fleet __complete` itself, so they stay in sync with the
# config (repositories.json) — nothing is hardcoded here.

_fleet_complete() {
  local cur prev words cword
  # `declare -F` is unreliable in zsh (-F means float there), so probe with `type`.
  if type _get_comp_words_by_ref >/dev/null 2>&1; then
    _get_comp_words_by_ref -n : cur prev words cword
  else
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD
  fi

  local fleet="${words[0]}" sub="${words[1]:-}"

  # position 1: subcommand
  if [ "$cword" -le 1 ]; then
    COMPREPLY=( $(compgen -W "$("$fleet" __complete cmds 2>/dev/null)" -- "$cur") )
    return
  fi

  case "$sub" in
    add|list|ls|status|st|each)
      # position 2: repo name
      [ "$cword" -eq 2 ] && \
        COMPREPLY=( $(compgen -W "$("$fleet" __complete repos 2>/dev/null)" -- "$cur") )
      ;;
    open)
      # position 2: repo name; position 3: worktree folder
      if [ "$cword" -eq 2 ]; then
        COMPREPLY=( $(compgen -W "$("$fleet" __complete repos 2>/dev/null)" -- "$cur") )
      elif [ "$cword" -eq 3 ]; then
        COMPREPLY=( $(compgen -W "$("$fleet" __complete folders "${words[2]}" 2>/dev/null)" -- "$cur") )
      fi
      ;;
    rm|remove)
      # skip flags (-f/-b) to find repo (1st non-flag) and folder (2nd non-flag)
      local i args=()
      for ((i=2; i<cword; i++)); do
        case "${words[i]}" in -*) ;; *) args+=("${words[i]}") ;; esac
      done
      if [ "${#args[@]}" -eq 0 ]; then
        COMPREPLY=( $(compgen -W "$("$fleet" __complete repos 2>/dev/null)" -- "$cur") )
      elif [ "${#args[@]}" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "$("$fleet" __complete folders "${args[0]}" 2>/dev/null)" -- "$cur") )
      fi
      ;;
  esac
}

complete -F _fleet_complete fleet ./fleet
