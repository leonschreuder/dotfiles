#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# symlinks from here
homeLinks=".gitconfig .gprofile .ideavimrc .inputrc .tmux.conf"
for f in $homeLinks; do
  echo "creating symlink in home for $f"
  ln -fs $SCRIPT_PATH/$f $HOME/$f
done


# load ~/.gprofile
rcFile="$HOME/.bashrc"
if ! grep -q ".gprofile" $rcFile; then
  echo "add loading of ~/.gprofile to $rcFile"
  echo '[[ -s ~/.gprofile ]] && source ~/.gprofile' >> $rcFile
else
  echo "already loading .gprofile from $rcFile"
fi


read -p "Install solarized for gnome-terminal? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  tmpDir="$(mktemp -d)"
  (
    cd $tmpDir
    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git solarized
    ./solarized/install.sh
  )
  [[ $? -ne 0 ]] && echo "ERROR during installation. Rerun with '$tmpDir/solarized/install.sh'"
fi


echo
echo "--------"
echo "DONE"
echo "Optional manual installation steps:"
echo "- create ~/.lprofile"
