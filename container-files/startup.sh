#!/bin/bash
set -eu
export TERM=xterm
# Bash Colors
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`
# Functions
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[VSFTPD `date +'%T'`]${reset} $@";
  else echo; fi
}


log "VSFTPD daemon starting"
# Run vsftpd:
&>/dev/null /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf