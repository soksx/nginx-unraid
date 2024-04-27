#!/command/with-contenv sh
# shellcheck shell=sh

set -e

SCRIPT=/tmp/logrotate.sh

log_info 'Configuring logrotate cron tasks...'

# Create the crontab file in a suitable location.
s6-echo "* * */2 * * $SCRIPT" > /etc/crontabs/$NGINXUSER

# Running script
$SCRIPT