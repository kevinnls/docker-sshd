FROM alpine:3.16

RUN apk add --no-cache \
    openssh-server \
    openssh-client

COPY container-entrypoint.sh /bin/container-entrypoint.sh

RUN chmod +x /bin/container-entrypoint.sh

RUN adduser \
    -h/var/sshd \
    -s/sbin/nologin \
    -D \
    ssh-daemon

COPY default_config /var/sshd/config

RUN mkdir \
      /var/sshd/config.d /var/sshd/keys \
    && \
    chown -R ssh-daemon:ssh-daemon \
      /var/sshd/

USER ssh-daemon
ENTRYPOINT ["/bin/container-entrypoint.sh"]
