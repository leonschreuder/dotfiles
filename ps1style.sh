#!/usr/bin/env bash
#
# Custom styling of the ps1 line
#======================================================================
# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

# BLACK="\[$(tput setaf 0)\]"
# RED="\[$(tput setaf 1)\]"
# GREEN="\[$(tput setaf 2)\]"
# YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
PINK="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"
NO_COLLOR="\[$(tput sgr0)\]"

# character repeated to indicate nesting depth
PRE_CHAR='❱'
PREFIX_COLOR=$BLUE

# tmux & shell state
#--------------------------------------------------------------------------------

getNestingDepthIndicator() {
  result=''
  for ((i=0; i<$LC_NESTING_DEPTH; i++)); do
    result=$result$PRE_CHAR
  done
  echo $result
}

getPrettyTmuxSessionCount() {
  count=$(getTmuxSessionCount)
  if [[ count -gt 0 ]]; then
    echo $(intToSubScript $count)
  fi
}

getTmuxSessionCount() {
  echo $(tmux ls 2> /dev/null | wc -l | xargs)
}

intToSubScript() {
  echo -e "\\u208$1"
}

intToSuperScript() {
  # Unicode is an inconsistent mess, also cross platform sucks for superscript,
  # so I've just hard-coded the chars and hope git or the browser will take
  # care of the encoding for me.
  case $1 in
    "1") echo '¹' ;;
    "2") echo '²' ;;
    "3") echo '³' ;;
    "4") echo '⁴' ;;
    "5") echo '⁵' ;;
    "6") echo '⁶' ;;
    "7") echo '⁷' ;;
    "8") echo '⁸'
  esac
  echo
}

# Job state
#--------------------------------------------------------------------------------

getPrettyJobCount() {
  jobCount=$( getJobCount )
  if [ $jobCount -gt 0 ]; then
    echo "$(intToSuperScript $jobCount)"
  else
    echo ''
  fi
}

getJobCount() {
  echo $( jobs | wc -l | xargs )
}

# GIT state
#--------------------------------------------------------------------------------

# prints '(*master)' when on master. The '*' is added when there are local changes
getPrettyGitState() {
  gitBranch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ "$gitBranch" == "" ]]; then
    echo "∙"
  else
    echo "$(getGitStatusIndicator)$gitBranch"
  fi
}

getGitBranch() {
  gitBranch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ "$gitBranch" == "" ]]; then
    echo "∙"
  else
    echo "$gitBranch"
  fi
}

getGitStatusIndicator() {
  status="$(git status --porcelain 2>/dev/null)"
  [[ "$status" == "" ]] && return
  #  -  everything in index
  #  +  local changes on known files
  #  *  repo has unstaged files

  hasStaged="false"
  hasUnstaged="false"
  hasUntracked="false"
  while IFS=$'\n' read -r line; do
    if [[ "$line" =~ ^[A-Z] ]]; then  # has staged changes
      hasStaged="true"
    fi
    if [[ "$line" =~ ^.[A-Z] ]]; then  # current change is unstaged, or has unstaged parts
      hasUnstaged="true"
    fi
    if [[ "$line" =~ ^\? ]]; then  # has untracked files
      hasUntracked="true"
    fi
  done <<< "$status"
  indicator=""
  [[ "$hasStaged" == "true" ]] && indicator+="+"
  [[ "$hasUnstaged" == "true" ]] && indicator+="-"
  [[ "$hasUntracked" == "true" ]] && indicator+="?"


  echo -n "$indicator"
}


# `man bash` -> PROMPTING
# methods need escaping to not interfere with special charactes


lineStartIcon1="╭"
lineStartIcon2="╰"
timeIcon="⧗"
pathIcon="▸"
gitIcon=""
# 𝌆 ◯  ¶ ◴ 🮟🮜 ◣◤ ◺◸ ┏ ╓ ╭╰

time="$PREFIX_COLOR$timeIcon$NO_COLLOR \t" # \t adds time with seconds
path="$PREFIX_COLOR$pathIcon$NO_COLLOR \w" # \w adds current working dir
git="$PREFIX_COLOR$gitIcon$NO_COLLOR \$(getGitBranch) \$(getGitStatusIndicator)"

tmuxSessionCount="$PREFIX_COLOR\$(getPrettyTmuxSessionCount)$NO_COLLOR"
nestingIndicator="$PREFIX_COLOR\$(getNestingDepthIndicator)$NO_COLLOR"
jobCount="$WHITE\$(getPrettyJobCount)$NO_COLLOR"

prefixLine1="$PREFIX_COLOR$lineStartIcon1$NO_COLLOR"
prefixLine2="$PREFIX_COLOR$lineStartIcon2$NO_COLLOR"

completePS1=""
completePS1+="$prefixLine1 $time   $path   $git"
completePS1+="\n"
completePS1+="$prefixLine2 $tmuxSessionCount$nestingIndicator $jobCount$ "

export PS1="$completePS1"
