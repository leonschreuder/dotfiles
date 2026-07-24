#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
toSymlinkUnix=".gitconfig .gprofile .ideavimrc .inputrc .tmux.conf"

main() {
  summary=()

  symlinkFiles
  setupCustomRcLoading

  installZ
  installAptPackages

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

installZ() {
  mkdir -p ~/lib/
  cd ~/lib/
  git clone https://github.com/skywind3000/z.lua
}

installAptPackages() {
  sudo apt-get install fonts-powerline
  sudo apt install fzf
  sudo apt install lua5.4
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
