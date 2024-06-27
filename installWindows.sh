#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
toCopyWin=".gitconfig .gprofile .ideavimrc .inputrc .minttyrc"

main() {
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
