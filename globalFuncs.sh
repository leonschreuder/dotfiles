#!/bin/sh


# credit https://superuser.com/a/611582/362137
countdown() {
   refDate=$(($(date +%s) + $1))
   while [ "$refDate" -ge $(date +%s) ]; do 
     newTime="$(date -u --date @$(($refDate - $(date +%s))) +%H:%M:%S)"
     echo -en "\ek$newTime\e\\" # update tmux console
     echo -ne "$newTime\r"
     sleep 0.1
   done
   echo -en "\ekbash\e\\"
}

# credit https://superuser.com/a/611582/362137
stopwatch() {
  refDate=$(date +%s)
  while true; do
    echo -ne "$(date -u --date @$(( $(date +%s) - $refDate)) +%H:%M:%S)\r"
    sleep 0.1
  done
}
