#!/bin/sh

# Log file for recording script activity
LOGFILE="/var/log/logrotate_timer.log"

# Function to execute logrotate and handle errors
run_logrotate() {
    if logrotate /etc/logrotate.d/nginx; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Logrotate completed successfully." >> $LOGFILE
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error during logrotate." >> $LOGFILE
    fi
}

# Log initialization of the logrotate timer
echo "$(date '+%Y-%m-%d %H:%M:%S') - Logrotate Timer initialized" >> $LOGFILE

# Execute logrotate immediately at start
run_logrotate