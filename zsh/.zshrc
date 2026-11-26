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
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# fleet completion (bash-style; needs zsh's compinit + bashcompinit shims)
if [ -f "$HOME/.config/fleet/completion.bash" ]; then
  autoload -U compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
  source "$HOME/.config/fleet/completion.bash"
fi

# fleet wrapper: lets `open`/`add`/`rm` cd the current shell into a worktree.
# The command can't change the parent shell's cwd, so it writes the target path
# to $FLEET_CD_FILE and we cd here.
fleet() {
  case "${1:-}" in
    open|add|rm|remove)
      local _cd _rc _dir
      _cd="$(mktemp "${TMPDIR:-/tmp}/fleet-cd.XXXXXX")" || { command fleet "$@"; return; }
      FLEET_CD_FILE="$_cd" command fleet "$@"; _rc=$?
      _dir="$(cat "$_cd" 2>/dev/null)"; rm -f "$_cd"
      [ -n "$_dir" ] && [ -d "$_dir" ] && cd "$_dir"
      return $_rc
      ;;
    *) command fleet "$@" ;;
  esac
}

if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi

export REDISMS_SYSTEM_BINARY=/opt/homebrew/opt/redis/bin/redis-server

alias claude-pessoal='CLAUDE_CONFIG_DIR="$HOME/.claude-pessoal" claude'
alias claude-empresa='CLAUDE_CONFIG_DIR="$HOME/.claude-empresa" claude'

