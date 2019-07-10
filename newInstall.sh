#!/bin/bash

SCRIPT_PATH="$(readlink -e "${BASH_SOURCE[0]}")";
SCRIPT_DIR=$(dirname $SCRIPT_PATH)


# symlinks from here
homeLinks=".gitconfig .gprofile .ideavimrc .inputrc .tmux.conf"
for f in $homeLinks; do
  echo "creating symlink in home for $f"
  ln -fs $SCRIPT_DIR/$f $HOME/$f
done


# load ~/.gprofile
rcFile="$HOME/.bashrc"
echo "add loading of ~/.gprofile to $rcFile"
echo '[[ -s ~/.gprofile ]] && source ~/.gprofile' >> $rcFile


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
