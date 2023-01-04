#!/bin/bash

function install() {
  SUDO=$(which sudo 2>/dev/null)
  # don't execute where it doesn't have (running from a container)
  if [ -z $SUDO ] ; then
    SUDO=""
  fi

  # ssh-key
  ssh-keygen -t rsa -f ~/.ssh/id_rsa_bitbucket_rafaelmees -N ""
  ssh-keygen -t rsa -f ~/.ssh/id_rsa_github_rafaelmees -N ""
  ssh-keygen -t rsa -f ~/.ssh/id_rsa_gitlab_rafaelmees -N ""

  # brew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # tmux
  brew install coreutils curl git htop neovim tmux
  mkdir -p ~/.tmux
  cp tmux/.tmux.conf ~/.tmux.conf

  # powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

  # vscode powerline
  git clone --depth=1 https://github.com/pcwalton/vscode-powerline.git ~/.vscode_powerline

  # rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  # vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  cp vim/.vimrc ~/.vimrc

  # zsh
  cp zsh/.zshrc ~/.zshrc_user
  echo ". ~/.zshrc_user" >> ~/.zshrc
  source ~/.zshrc

  # asdf
  git clone --depth=1 https://github.com/asdf-vm/asdf.git ~/.asdf
  asdf plugin-add flutter
}

install
