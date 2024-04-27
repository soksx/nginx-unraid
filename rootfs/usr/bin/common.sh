#!/bin/sh

set -e

CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'
export CYAN BLUE YELLOW RED RESET

PUID=${PUID:-0}
PGID=${PGID:-0}

# If changing the username and group name below,
# ensure all references to this user is also changed.
# See rootfs/etc/logrotate.d/nginx
# and rootfs/etc/nginx/nginx.conf
NGINXUSER=nginx-unraid
NGINXGROUP=nginx-unraid
NGINXHOME=/tmp/nginx-unraid
export NGINXUSER NGINXGROUP NGINXHOME

if [[ "$PUID" -ne '0' ]] && [ "$PGID" = '0' ]; then
	# set group id to same as user id,
	# the user probably forgot to specify the group id and
	# it would be rediculous to intentionally use the root group
	# for a non-root user
	PGID=$PUID
fi

export PUID PGID

log_info () {
	echo -e "${BLUE}❯ ${CYAN}$1${RESET}"
}

log_error () {
	echo -e "${RED}❯ $1${RESET}"
}

# The `run` file will only execute 1 line so this helps keep things
# logically separated

log_fatal () {
	echo -e "${RED}--------------------------------------${RESET}"
	echo -e "${RED}ERROR: $1${RESET}"
	echo -e "${RED}--------------------------------------${RESET}"
	/run/s6/basedir/bin/halt
	exit 1
}

# param $1: group_name
get_group_id () {
	if [ "${1:-}" != '' ]; then
		getent group "$1" | cut -d: -f3
	fi
}