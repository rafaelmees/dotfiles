#!/bin/bash

function install() {
    SUDO=$(which sudo 2>/dev/null)
    # don't execute where it doesn't have (running from a container)
    if [ -z $SUDO ] ; then
        SUDO=""
    fi

    $SUDO dnf install -y \
        gvim \
        tmux \
        python-pip
    --best

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    curl -fsSL get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh

    $SUDO curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    $SUDO chmod +x /usr/local/bin/docker-compose
    $SUDO systemctl enable docker

    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

    pip install --user powerline-status

    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
    $SUDO fc-cache -vf ~/.fonts/

    cp vim/.vimrc ~/.vimrc
    mkdir -p ~/.vim/colors && cp vim/colors/monokai.vim ~/.vim/colors/monokai.vim

    cp bash/.bashrc ~/.bashrc_user
    echo ". ~/.bashrc_user" >> ~/.bashrc

    mkdir -p ~/.config/powerline/themes/tmux
    cp tmux/default.json ~/.config/powerline/themes/tmux/default.json
    mkdir -p ~/.config/powerline/themes/shell
    cp bash/default.json ~/.config/powerline/themes/shell/default.json
    mkdir -p ~/.tmux
    cp tmux/.tmux.conf ~/.tmux.conf
}

install
