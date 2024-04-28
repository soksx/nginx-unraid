#!/bin/sh
set -e

log_info() {
    echo "$1"
}

# Configuring the NGINXGROUP group
log_info "Configuring $NGINXGROUP group ($PGID) ..."
if ! getent group "$NGINXGROUP" >/dev/null; then
    # Add group
    addgroup -g "$PGID" "$NGINXGROUP"
fi

# Configuring the NGINXUSER user
log_info "Configuring $NGINXUSER user ..."
if ! id -u "$NGINXUSER" >/dev/null 2>&1; then
    # Add user
    adduser -D -G "$NGINXGROUP" -u "$PUID" -h "$NGINXHOME" -s /sbin/nologin "$NGINXUSER"
fi

# Check the created group against the $PGID
if [ "$(getent group "$NGINXGROUP" | cut -d: -f3)" != "$PGID" ]; then
    echo "ERROR: Unable to properly set the group ID"
    exit 1
fi

# Check if the user is assigned in the target group
if [ "$(id -g "$NGINXUSER")" != "$PGID" ]; then
    echo "ERROR: Unable to properly set the group for the user"
    exit 1
fi

# Home directory for user
mkdir -p "$NGINXHOME"
chown -R "$PUID:$PGID" "$NGINXHOME"