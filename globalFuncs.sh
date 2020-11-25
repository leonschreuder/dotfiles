#!/bin/sh


# credit https://superuser.com/a/611582/362137
countdown() {
   refDate=$(($(date +%s) + $1))

   windowId="$(tmuxW display-message -p '#{window_id}')"
   while [ "$refDate" -ge $(date +%s) ]; do 
     newTime="$(date -u --date @$(($refDate - $(date +%s))) +%H:%M:%S)"
     echo -ne "$newTime\r" # print new time
     tmuxW rename-window -t "$windowId" $newTime # update tmux console
     sleep 0.1
   done
   tmuxW setw -t "$windowId" automatic-rename
}

tmuxW() { # wrapper around tmux to only execute if tmux is available
  which tmux &>/dev/null && tmux $@
}

# credit https://superuser.com/a/611582/362137
stopwatch() {
  refDate=$(date +%s)
  while true; do
    echo -ne "$(date -u --date @$(( $(date +%s) - $refDate)) +%H:%M:%S)\r"
    sleep 0.1
  done
}
