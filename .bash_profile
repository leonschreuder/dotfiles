export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

[[ -s ~/.bashrc ]] && source ~/.bashrc

export PATH=/usr/local/bin:$PATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
