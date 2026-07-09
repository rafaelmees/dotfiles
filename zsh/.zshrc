# Homebrew on PATH (macOS: /opt/homebrew or /usr/local; Linux: linuxbrew).
if ! command -v brew >/dev/null 2>&1; then
  for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew \
               /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
    [ -x "$_brew" ] && eval "$("$_brew" shellenv)" && break
  done
  unset _brew
fi

# Load every SSH key into the agent (use the macOS keychain when available).
_ssh_add_opts=()
[ "$(uname -s)" = "Darwin" ] && _ssh_add_opts=(--apple-use-keychain)
for _pub in ~/.ssh/*.pub(N); do
  _key="${_pub%.pub}"
  [ -f "$_key" ] && ssh-add "${_ssh_add_opts[@]}" "$_key" >/dev/null 2>&1
done
unset _pub _key _ssh_add_opts

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
