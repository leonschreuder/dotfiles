#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Install or update kitty
#------------------------------------------------------------------------
# https://sw.kovidgoyal.net/kitty/binary/
if [[ "$1" != "-s" ]]; then
  echo "Installing kitty..."
  tmpFile="$(mktemp --suffix=.sh)"
  if ! curl -L https://sw.kovidgoyal.net/kitty/installer.sh > "$tmpFile"; then
    echo "Could not get install script. Probably curl problems. Fix manually and/or skip using '-s'"
    echo "To install it yourself, see: https://sw.kovidgoyal.net/kitty/binary/"
    exit 1
  fi
  chmod +x "$tmpFile"
  $tmpFile
else
  echo "Skipping kitty installation..."
fi

echo "Symlinking kitty.conf..."
ln -fs "$SCRIPT_PATH/kitty.conf" ~/.config/kitty/kitty.conf

if [[ ! -d ~/.config/kitty/one-dark-pro-theme ]]; then
  echo "Installing one-dark-pro theme..."
  git clone --depth 1 https://github.com/nzantopp/OneDark-Pro-Kitty-Theme ~/.config/kitty/one-dark-pro-theme
else
  echo "Skipping theme installation. Appears already installed to ~/.config/kitty/one-dark-pro-theme"
fi

# Change App-Icon:
#------------------------------------------------------------------------
# https://sw.kovidgoyal.net/kitty/faq/#i-do-not-like-the-kitty-icon
# ~/.local/share/applications/kitty.desktop
# https://github.com/mtklr/kitty-nyancat-icon/blob/main/kitty.app.png
if [[ ! -e ~/.config/kitty/kitty.app.png ]]; then
  echo "Downloading custom app icon..."
  curl -k https://github.com/mtklr/kitty-nyancat-icon/blob/main/kitty.app.png?raw=true > ~/.config/kitty/kitty.app.png
fi

# desktop integration on linux: 
#------------------------------------------------------------------------
# from https://sw.kovidgoyal.net/kitty/binary/
echo "Integration into linux desktop..."
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.config/kitty/kitty.app.png|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
