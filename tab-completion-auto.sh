#!/bin/bash
# [Bash Tab-Completion Automation]
#  This script provides an example how to build a tab completion
#  from a set of user-defined functions automatically.
#  Each function must be defined with a naming pattern to reach 
#  to the root function or reach to the target sub-function.
#  The root function is a function that the tab completion begins
#  In this sample script, 'myapp' is the root function for all others.
#  All the sub-functions must start with "__" prefix string 
#  and concatenate their ancestor's names using "-" similarly to a path.
# 
# [Usage]
#  In order to use the script, please grep and replace all 'myapp' to your function.
#  And then update the sub-functions and their function body.
# 

__myapp() { ## help description A
    echo A "$*"
}

__myapp-secondB() { ## help description A-B
    echo A-B "$*"
}

__myapp-secondC() { ## help description A-C
    echo A-C "$*"
}

__myapp-secondD() {
    echo A-D "$*"
}

__myapp-secondB-thirdX() { ## help description A-B-X
    echo A-B-X "$*"
}

__myapp-secondB-thirdY() {
    echo A-B-Y "$*"
}

__myapp-secondC-thirdX() {
    echo A-C-X "$*"
}

__myapp-secondC-thirdY() {
    echo A-C-Y "$*"
}

__myapp-secondC-thirdZ() {
    echo A-C-Z "$*"
}

__myapp-help() {
    local FUNCS
    FUNCS=$(grep "^__[A-Za-z0-9\-_]\(\)" "$_myappFile" | sort | sed 's/() {.*//g; s/__//g')
    for entry in $FUNCS; do
        IFS='-' read -r -a array <<< "$entry"
        echo "${array[@]}" "$(grep "^__${entry}()" "$_myappFile" | sed 's/.*{//')" | \
        awk 'BEGIN {FS = "##"}; {printf "\033[36m%-30s\033[0m %s\n", $1, $2}'
    done
}

myapp() {
    local fname="__${FUNCNAME[0]}"
    local _matchargs=$*
    local _matchfname=$fname
    while (($#)); do
        fname="$fname $1"
        fname=${fname//" "/"-"}
        shift
        if [[ $(type -t "${fname}") == function ]]; then 
            _matchfname=$fname
            _matchargs=$*
        fi
    done
    # echo matched fname "$_matchfname"
    # echo matched args "$_matchargs"
    $_matchfname "$_matchargs"
}

_myappComplete() {
    local CUR
    local FULLNAME
    local FUNCNAMES
    FULLNAME=${COMP_LINE//" "/"-"}
    FUNCNAMES=$(grep "^__$FULLNAME" "$_myappFile" | sort | sed 's/() {.*//g' | sed 's/__//g')
    COMPREPLY=()
    WORDS=""
    for fname in $FUNCNAMES; do
        IFS='-' read -r -a farray <<< "$fname"
        WORDS="$WORDS ${farray[$COMP_CWORD]}"
    done
    local _COMPGEN
    _COMPGEN=$(compgen -W "$WORDS" -- "$CUR")
    COMPREPLY=($_COMPGEN)
    return 0
}

_myappFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
complete -F _myappComplete myapp
