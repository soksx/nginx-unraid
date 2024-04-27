FROM nginx:alpine-slim
ARG TARGETPLATFORM
# Set env vars
ENV SUPPRESS_NO_CONFIG_WARNING=1 \
	S6_BEHAVIOUR_IF_STAGE2_FAILS=1 \
	S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
	S6_FIX_ATTRS_HIDDEN=1 \
	S6_KILL_FINISH_MAXTIME=10000 \
	S6_VERBOSITY=1
# Install and configure logrotate
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf \
    && apk update \
    && apk add --no-cache jq logrotate curl inotify-tools \
    && rm -rf /var/cache/apk/*
# s6 overlay
COPY scripts/install-s6 /tmp/install-s6
RUN chmod +x /tmp/install-s6 && /tmp/install-s6 "${TARGETPLATFORM}" && rm -f /tmp/install-s6
# logrotate
COPY scripts/logrotate.sh /tmp/logrotate.sh
RUN chmod +x /tmp/logrotate.sh
# Remove docker entrypoint
RUN rm -Rf /docker-*
# Copy all configuration files
COPY rootfs /
# Grant logrotate config permissions
RUN chmod 644 /etc/logrotate.d/nginx
# Expose public port
EXPOSE 8080
# Expose /data volume
VOLUME [ "/data" ]
ENTRYPOINT [ "/init" ]