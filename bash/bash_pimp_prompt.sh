#!/bin/bash

# Got this from:
# https://gist.github.com/790086

parse_hg_patchque() {
    git symbolic-ref -q HEAD &> /dev/null && return
	topp=$(hg qtop 2> /dev/null) || topp=$(hg branch 2> /dev/null) || return
	printf " ${1:-(%s)}" "${topp}"
}

parse_git_branch() {
  ref=$(git symbolic-ref -q HEAD 2> /dev/null) || return
  printf " ${1:-(%s)}" "${ref#refs/heads/}"
}

parse_svn_revision() {
  local DIRTY REV=$(svn info 2>/dev/null | grep Revision | sed -e 's/Revision: //')
  [ "$REV" ] || return
  [ "$(svn st)" ] && DIRTY=' *'
  echo "(r$REV$DIRTY)"
}

pimp_prompt() {
  local        BLUE="\[\033[0;34m\]"
  local   BLUE_BOLD="\[\033[1;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  #local       WHITE="\[\033[0;37m\]"
  local       WHITE="\[\033[0;00m\]"
  local  WHITE_BOLD="\[\033[1;37m\]"  
  local  LIGHT_GRAY="\[\033[0;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
#PS1="${TITLEBAR}[$WHITE\u@$BLUE_BOLD\h$WHITE \w$GREEN\$(parse_git_branch)\$(parse_svn_revision) $RED\$(~/.rvm/bin/rvm-prompt v g)$WHITE]\$ "
#PS1="${TITLEBAR}[$WHITE\u@$BLUE_BOLD\h$WHITE \w$GREEN\$(parse_git_branch)\$(parse_svn_revision)$WHITE]\$ "
PS1="[\u@\h \w$GREEN\$(parse_git_branch)\$(parse_svn_revision)\$(parse_hg_patchque)$WHITE]\$ "
PS2='> '
PS4='+ '
}
pimp_prompt
