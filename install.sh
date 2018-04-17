#!/bin/bash

function install() {
	SUDO=$(which sudo 2>/dev/null)
	# don't execute where it doesn't have (running from a container)
	if [ -z $SUDO ] ; then
		SUDO=""
	fi

	$SUDO dnf install -y \
		vim \
		tmux \
		git \
	--best
	
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	curl -fsSL get.docker.com -o get-docker.sh
	sh get-docker.sh
	$SUDO rm get-docker.sh

	gsettings set org.gnome.desktop.wm.preferences button-layout 'close,maximize,minimize:'

	pip install --user powerline-status

	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
	mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	$SUDO fc-cache -vf ~/.fonts/

	cp vim/.vimrc ~/.vimrc

	cp bash/.bashrc ~/.bashrc

	mkdir -p ~/.config/powerline/themes/tmux
	cp tmux/default.json ~/.config/powerline/themes/tmux/default.json
	mkdir -p ~/.tmux
	cp tmux/.tmux.conf ~/.tmux/.tmux.conf

	#create signature file
	echo $'Created by \n\tRafael Mees' >~/.signature
}

install

