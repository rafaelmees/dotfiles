if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias vim='gvim -v'

. $HOME/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
