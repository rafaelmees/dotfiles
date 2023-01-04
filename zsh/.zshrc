# powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# tmux
# tmux source-file ~/.tmux.conf
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

# vim
alias vim='nvim'

# ssh keys
ssh-add /Users/rafaelmees/.ssh/id_rsa_bitbucket_rafaelmees 2> /dev/null
ssh-add /Users/rafaelmees/.ssh/id_rsa_github_rafaelmees 2> /dev/null
ssh-add /Users/rafaelmees/.ssh/id_rsa_gitlab_rafaelmees 2> /dev/null

# paths
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/.local/bin":

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh

# flutter
export FLUTTER_ROOT="$(asdf where flutter)"