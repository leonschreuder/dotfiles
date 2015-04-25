source ~/Sync/dotfiles/git-completion.bash

export GRADLE_HOME=/usr/local/Cellar/gradle/
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH="/Applications/Android Studio.app/sdk/platform-tools":$PATH
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export GRADLE_HOME="/usr/local/Cellar/gradle/"
export SONAR_RUNNER_HOME=/usr/local/Cellar/sonar-runner/2.4/libexec

alias ctags='/usr/local/bin/ctags'


#echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
