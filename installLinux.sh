#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
toSymlinkUnix=".gitconfig .gprofile .ideavimrc .inputrc .tmux.conf"

main() {
  summary=()

  symlinkFiles
  setupCustomRcLoading

  # installSolarized
  installOneDark

  installPowerlineFonts

  echo
  echo "DONE"
  echo "--------"
  echo "Next steps:"
  for line in "${summary[@]}"; do
    echo "- $line"
  done
}


symlinkFiles() {
  for f in $toSymlinkUnix; do
    echo "creating symlink in home for $f"
    ln -fs "$SCRIPT_PATH/$f" "$HOME/$f"
  done
}

setupCustomRcLoading() {
  # load ~/.gprofile
  rcFile="$HOME/.bashrc"
  if ! grep -q ".gprofile" "$rcFile"; then
    echo "add loading of ~/.gprofile to $rcFile"
    echo '[[ -s ~/.gprofile ]] && source ~/.gprofile' >> "$rcFile"
  else
    echo "already loading .gprofile from $rcFile"
  fi

  touch "$HOME/.lprofile"
  summary+=("Fill $HOME/.lprofile with cusom settings like JAVA_HOME etc.")
}

installOneDark() {
  tmpDir="$(mktemp -d)"
  cd "$tmpDir" || exitWithError "could not cd into '$tmpDir'"
  curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh -O
  chmod +x one-dark.sh
  ./one-dark.sh
}

installSolarized() {
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
}

installPowerlineFonts() {
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
}

exitWithError() {
  re='?(-)+([0-9])'
  [[ -n $2 && $1 == $re ]] && { exitCode=$1; shift; } || exitCode=1
  echo -e "ERROR: $@" >&2
  exit $exitCode
}


if [[ "$0" == "$BASH_SOURCE" ]]; then
  main "$@"
fi

# vim:fdm=marker
