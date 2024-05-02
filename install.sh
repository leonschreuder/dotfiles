#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
toSymlinkUnix=".gitconfig .gprofile .ideavimrc .inputrc .tmux.conf"
toCopyWin=".gitconfig .gprofile .ideavimrc .inputrc .minttyrc"

main() {
  if isWin -q; then
    setupWindows
  else
    setupUnix
  fi
}

setupWindows() {
  if [[ "$USERPROFILE" != "$(cygpath -w "$HOME")" ]]; then
    exitWithError "Your \$HOME='$HOME' but your \$USERPROFILE='$USERPROFILE'. Please fix that first."
  fi

  echo "Copying files into \$HOME:$toCopyWin"
  for f in $toCopyWin; do
    cp $SCRIPT_PATH/$f $HOME/$f
  done

  rcFile="$HOME/.bash_profile"
  touch "$rcFile"
  if ! grep -q ".gprofile" $rcFile; then
    echo "add loading of ~/.gprofile to $rcFile"
    echo '[[ -s ~/.gprofile ]] && source ~/.gprofile' >> $rcFile
  else
    echo "already loading .gprofile from $rcFile"
  fi

  touch $HOME/.lprofile

  # install.sh because 'dirname' is being called to get the scriptdir
  sed -i "s%^SCRIPT_PATH=.*%SCRIPT_PATH=\"$SCRIPT_PATH/install.sh\"%" $HOME/.gprofile
  
}


setupUnix() {
  summary=()

  # symlinks from here
  for f in $toSymlinkUnix; do
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

  touch $HOME/.lprofile
  summary+=("Fill $HOME/.lprofile with cusom settings like JAVA_HOME etc.")


  echo "Install solarized?"
  echo "[0] gnome terminal"
  echo "[1] xfce4-terminal"
  read -p "Anser (any other skips): " -n 1 -r REPLY

  if [[ $REPLY =~ ^0$ ]]; then
    echo "Installing for xfce4-terminal"
    tmpDir="$(mktemp -d)"
    (
      cd $tmpDir
      git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git solarized
      ./solarized/install.sh
    )
    if [[ $? -ne 0 ]]; then
      echo "ERROR during installation. Repo downloaded to '$tmpDir/solarized'"
    fi
  elif [[ $REPLY =~ ^1$ ]]; then
    tmpDir="$(mktemp -d)"
    (
      cd "$tmpDir"
      git clone https://github.com/nimbosa/solarized-xfce4-terminal-colors.git solarized
      mkdir -p ~/.config/Terminal/
      cp ./solarized/dark/terminalrc ~/.config/Terminal/terminalrc
    )
    if [[ $? -ne 0 ]]; then
      echo "ERROR during installation. Repo downloaded to '$tmpDir/solarized'"
    fi
  fi

  # Powerline fonts allow displaying some fancy symbols in neovim (when using
  # the airline plugin).
  # https://github.com/vim-airline/vim-airline-themes
  # https://github.com/powerline/fonts
  read -p "Install powerline fonts? " -n 1 -r REPLY
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    tmpDir="$(mktemp -d)"
    (
      cd $tmpDir
      git clone https://github.com/powerline/fonts.git --depth=1
      cd fonts
      ./install.sh
    )
    if [[ $? -ne 0 ]];then
      exitWithError "Error during installation. Repo downloaded to '$tmpDir/fonts'"
    else
      summary+=("Restart the terminal and select 'Liberation Mono for Powerline' font.")
    fi
  fi

  echo
  echo "DONE"
  echo "--------"
  echo "Next steps:"
  for line in "${summary[@]}"; do
    echo "- $line"
  done

}

isWin() {
  [[ "$1" == "-q" ]] && local CMD_QUIET=true && shift
  case "`uname`" in
    CYGWIN* )
      echoQ "true"
      return 0
      ;;
    MINGW* )
      echoQ "true"
      return 0
      ;;
    MSYS_NT* )
      echoQ "true"
      return 0
      ;;
    *)
      echoQ "false"
      return 1
      ;;
  esac
}

exitWithError() {
  re='?(-)+([0-9])'
  [[ -n $2 && $1 == $re ]] && { exitCode=$1; shift; } || exitCode=1
  echo -e "ERROR: $@" >&2
  exit $exitCode
}

echoQ() {
  [[ "$CMD_QUIET" == "" ]] && echo $@ || :
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
  main "$@"
fi

# vim:fdm=marker

