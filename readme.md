These here are my dotfiles. I generally try to keep my setup
pretty basic, so have a look around.

The `install.sh` script tries to setup everything like I like it for the
current environment.


## Clean vserver setup guidelines

From a clean vserver, with nothing set up.

### check user setup (assume root)
$ users 						  # list current user
$ cat /etc/passwd 		# list all useres (including system)
$ grep -E '^UID_MIN|^UID_MAX' /etc/login.defs		# list user id range of non-system users (usuall 1000+)

#### create user
$ useradd -m <name>	  # add user (-m for create dir (use `mkhomedir_helper` if forgot to do that)) 
$ passwd <name>		    # add password for user
$ useradd <name> sudo	# add to sudo group
$ id <name>		        # list rights and groups for user

#### init user
$ su <name>		      # or log in again via ssh
$ chsh -s /bin/bash	# set bash as default shell

Should have auto-generated .bashrc

## Next steps

1. Install homebrew
2. Install tmux, git, neovim
3. clone and install.sh dotfiles (this repo)
4. clone and setup vim_settings
