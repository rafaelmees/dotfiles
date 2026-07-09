#!/usr/bin/env bash
#
# Installs the dotfiles via symlinks.
# - Idempotent: run it as many times as you like.
# - Backs up any existing file before replacing it.
# - brew always runs (already-installed packages are skipped, not re-installed).
#
# Usage:
#   ./install.sh            # install deps (brew) + create the symlinks
#   ./install.sh --upgrade  # also upgrade already-installed brew packages
#   ./install.sh --add-ssh  # also run ./add-ssh.sh to generate SSH keys
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

BREW_FORMULAE=(tmux neovim starship tree-sitter-cli mise)
BREW_CASKS=(ghostty font-jetbrains-mono-nerd-font macmediakeyforwarder)

info()  { printf "\033[1;37m==>\033[0m %s\n" "$1"; }
ok()    { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }
warn()  { printf "\033[1;33m  !\033[0m %s\n" "$1"; }

# Creates a symlink $2 -> $1, backing up anything that already exists at $2.
link() {
  local src="$DOTFILES/$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  # Already the correct symlink? Nothing to do.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "$dest (already linked)"
    return
  fi

  # Something already there? Back it up.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    warn "backup: $dest -> $BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  ok "$dest -> $src"
}

install_brew_deps() {
  local do_upgrade="$1"

  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  info "Installing dependencies (brew)..."
  brew install "${BREW_FORMULAE[@]}"
  brew install --cask "${BREW_CASKS[@]}"

  if [ "$do_upgrade" = true ]; then
    info "Upgrading packages (brew upgrade)..."
    brew upgrade "${BREW_FORMULAE[@]}"
    brew upgrade --cask "${BREW_CASKS[@]}"
  fi

  ok "dependencies installed"
}

link_all() {
  info "Creating symlinks..."
  link "ghostty/config"           "$HOME/.config/ghostty/config"
  link "vim/init.lua"             "$HOME/.config/nvim/init.lua"
  link "vim/lazy-lock.json"       "$HOME/.config/nvim/lazy-lock.json"
  link "starship/starship.toml"   "$HOME/.config/starship.toml"
  link "mise/config.toml"         "$HOME/.config/mise/config.toml"
  link "tmux/tmux.conf"           "$HOME/.config/tmux/tmux.conf"
  link "zsh/.zshrc"               "$HOME/.zshrc"
}

main() {
  local do_upgrade=false do_add_ssh=false

  for arg in "$@"; do
    case "$arg" in
      --upgrade) do_upgrade=true ;;
      --add-ssh) do_add_ssh=true ;;
    esac
  done

  install_brew_deps "$do_upgrade"
  link_all
  [ "$do_add_ssh" = true ] && "$DOTFILES/add-ssh.sh"

  info "Done!"
  [ -d "$BACKUP_DIR" ] && warn "Old files saved in: $BACKUP_DIR"
  info "Restart the shell (exec zsh) and Ghostty to apply everything."
}

main "$@"
