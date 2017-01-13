#!/usr/bin/env bash
#
# Custom styling of the ps1 line
#======================================================================
# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

BLACK="\[$(tput setaf 0)\]"
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
PINK="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"
NO_COLLOR="\[$(tput sgr0)\]"

# character repeated to indicate nesting depth
PRE_CHAR='❱'


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
    echo $(tmux ls 2> /dev/null | wc -l | bc)
}

intToSubScript() {
    echo -e "\\u208$1"
}


# Job state
#--------------------------------------------------------------------------------

getPrettyJobCount() {
    jobCount=$( getJobCount )
    if [ $jobCount -gt 0 ]; then
        echo " ⁽$(intToSuperScript $jobCount)⁾"
        # echo " $jobCount" 
    else
        echo ''
    fi
}

intToSuperScript() {
    #Unicode is sort of a mess also cross platform sucks, so it is hard-coded it here
    case $1 in
        "1")
            echo '¹'
            ;;
        "2")
            echo '²'
            ;;
        "3")
            echo '³'
            ;;
        "4")
            echo '⁴'
            ;;
        "5")
            echo '⁵'
            ;;
        "6")
            echo '⁶'
            ;;
        "7")
            echo '⁷'
            ;;
        "8")
            echo '⁸'
    esac
    echo
}

getJobCount() {
    echo $( jobs | wc -l | bc )
}

# GIT state
#--------------------------------------------------------------------------------

# prints '(*master)' when on master. The '*' is added when there are local changes
getPrettyGitState() {
    gitBranch=$(getGitBranchName)
    if [[ -n $gitBranch ]]; then
        echo "($(getGitChangeIndicator)$gitBranch)"
    fi
}

getGitBranchName() {
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

getGitChangeIndicator() {
    `git diff --quiet --ignore-submodules HEAD 2>/dev/null`
    if [ $? != 0 ]; then
        echo "*"
    else
        echo ''
    fi
}


# `man bash` -> PROMPTING
# methods need escaping to not interfere with special charactes
completePS1=$BLUE
completePS1+="\$(getPrettyTmuxSessionCount)\$(getNestingDepthIndicator)"
completePS1+="\$(getPrettyJobCount)"
completePS1+=$NO_COLLOR

# \w adds current working dir
completePS1+=" \w "

completePS1+="\$(getPrettyGitState)"

completePS1+=$WHITE
completePS1+="$ "
completePS1+=$NO_COLLOR
export PS1=$completePS1