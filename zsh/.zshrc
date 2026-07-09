ssh-add --apple-use-keychain ~/.ssh/bitbucket_pessoal >/dev/null 2>&1
ssh-add --apple-use-keychain ~/.ssh/bitbucket_amaiseducacao >/dev/null 2>&1

# Aliases
alias ll='ls -alhF'
alias vim='nvim'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'

export PATH="$HOME/.local/bin:$PATH"

# mise - version manager (node, etc.)
# Enables automatic per-directory version switching and reads .nvmrc/.tool-versions/mise.toml.
eval "$(mise activate zsh)"

eval "$(starship init zsh)"

if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi
