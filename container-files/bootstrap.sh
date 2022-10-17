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

# create virtual ftp users
for i in $USERS ; do
    NAME=$(echo $i | cut -d'|' -f1)
    PASS=$(echo $i | cut -d'|' -f2)
    FOLDER=$(echo $i | cut -d'|' -f3)
    USERID=$(echo $i | cut -d'|' -f4)

  echo -e "${NAME}\n${PASS}" >> /etc/vsftpd/virtual_users.txt
  log "Updated /etc/vsftpd/virtual_users.txt"

  /usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db
  log "Updated vsftpd database"

  unset NAME PASS FOLDER USERID
done


# Anonymous access settings
if [ "${ANONYMOUS_ACCESS}" = "true" ]; then
  sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd/vsftpd.conf
  log "Enabled access for anonymous user."
fi

# Uploaded files world readable settings
if [ "${UPLOADED_FILES_WORLD_READABLE}" = "true" ]; then
  sed -i "s|local_umask=077|local_umask=022|g" /etc/vsftpd/vsftpd.conf
  log "Uploaded files will become world readable."
fi

# Custom passive address settings
if [ "${PASV_ADDRESS}" != "false" ]; then
  sed -i "s|pasv_address=|pasv_address=${PASV_ADDRESS}|g" /etc/vsftpd/vsftpd.conf
  log "Passive mode will advertise address ${PASV_ADDRESS}"
fi

if [ "${PASV_MAX_PORT}" != "false" ]; then
  sed -i "s|pasv_max_port=|pasv_max_port=${PASV_MAX_PORT}|g" /etc/vsftpd/vsftpd.conf
  log "Passive mode will advertise max port ${PASV_MAX_PORT}"
fi

if [ "${PASV_MIN_PORT}" != "false" ]; then
  sed -i "s|pasv_min_port=|pasv_min_port=${PASV_MIN_PORT}|g" /etc/vsftpd/vsftpd.conf
  log "Passive mode will advertise min port ${PASV_MIN_PORT}"
fi

# Get log file path
export LOG_FILE=`grep vsftpd_log_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`

# stdout server info:
if [ "${LOG_STDOUT}" = "true" ]; then
  log "Enabling Logging to STDOUT"
  mkdir -p /var/log/vsftpd
  touch ${LOG_FILE}
  tail -f ${LOG_FILE} | tee /dev/fd/1 &
elif [ "${LOG_STDOUT}" = "false" ]; then
  log "Logging to STDOUT Disabled"
else
  log "LOG_STDOUT available options are 'true/false'"
  exit 1
fi

#fix persmission ftp root folder
chmod -R 777 /opt/ftp/
log "Fix persmission ftp root folder"