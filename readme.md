Dotfiles
================================================================================

These here are my dotfiles. I generally try to keep my setup pretty basic, so
have a look around.

The `install.sh` script tries to setup everything like I like it for the
current environment.

System setup
------------------------------------------------------------

### Linux setup

1. Install homebrew
2. Install tmux, git, neovim, curl
3. Clone dotfiles (this repo) and run `./install.sh`
4. Clone and setup [vim_settings](https://github.com/leonschreuder/vim_settings) (see readme)

### Windows setup

1. Install gitbash + add english keyboard (+ company setup scripts)
2. clone and install.sh dotfiles (this repo)
3. clone and setup [vim_settings](https://github.com/leonschreuder/vim_settings)

### Agnostic setup

1. [Install KeepassXC](https://keepassxc.org/download/#linux)
  - get safe
  - settings:
      - enable browser integration
      - setup shortcut key
  - install browser Extension (see below)
2. Install firefox + plugins:
    - KeePassXC-Browser
    - uBlock Origin and or Adblock Plus
    - Ghostery (to block popups)
    - Simple Tab Groups (export tabs)
    - Dark Reader
    - when needed (Firefox Multi-Account Containers)
3. Install [Jet Brains Toolbox App](https://www.jetbrains.com/toolbox-app)
4. Install IntelliJ/Android Studio + plugins:
    - IdeaVim
    - Relative Line Numbers
    - ktfmt
    - IdeaVim-EasyMotion (+ Acejump)
    - Color scheme: [idea-semagic](https://github.com/leonschreuder/idea-semagic)

#### IntelliJ settings

##### Plugins:
- JustSemantics
- IdeaVim (should be automatically configured after dotfiles repo is installed)
- Settings Repository (Deprecated)


##### Setup settings repo
- Clone settings-repo repository: https://github.com/leonschreuder/idea-settings.git
- [File] > [Manage IDE Settings] > [Settings Repository]
    - [Upstream URL] Set to local repo
Every change will be commited in the local repo, but must be pushed manually.


##### Manual config (should come from Settings Repository)

- [Editor] 
    - [Inlay Hints] >
        - [Parameter names] off
        - [Code vision] > [Code author] off
    - [Code Style] > <each language>
        - [Wrapping and Braces] > Keep when reformatting
            - [ ] Comment at first column
        - [Code Generation] > Comment Code
            - [ ] Line Comment at first column
            - [x] Add a space at line comment start
            - [ ] Block comment at first column
- [Appearance & Behavior] 
    - [System Settings]
        - [ ] Reopen projects on startup


Clean vserver setup guidelines
------------------------------------------------------------

From a clean vserver, with nothing set up.

### check user setup (assume root)

```
users 						  # list current user
cat /etc/passwd 		# list all useres (including system)
grep -E '^UID_MIN|^UID_MAX' /etc/login.defs		# list user id range of non-system users (usuall 1000+)
```

#### create user

```
useradd -m <name>	  # add user (-m for create dir (use `mkhomedir_helper` if forgot to do that)) 
passwd <name>		    # add password for user
useradd <name> sudo	# add to sudo group
id <name>		        # list rights and groups for user
```

#### init user
$ su <name>		      # or log in again via ssh
$ chsh -s /bin/bash	# set bash as default shell

Should have auto-generated .bashrc

