# syntax=docker/dockerfile:1.3-labs

FROM alpine:3.16

RUN apk add --no-cache \
    openssh-server

COPY <<'EOF' /bin/container-entrypoint.sh
#!/bin/sh
set -e

gen_host_key(){
    case "${1}" in
      rsa )
	args="-trsa -b4096"
      ;;
      ecdsa | ed25519 )
	args="-t${1}"
      ;;
      * )
	>&2 printf 'ERR: invalid/non-supported key type'
	return 7
      ;;
    esac
    path="/var/sshd/keys/host_${1}_key"

    if ! [ -r "${path}" ]; then
	ssh-keygen -N \'\' -qf"${path}" "${args}"
    fi
    ssh-keygen -lf"${path}"
}

host_key_algos="${HOST_KEY_ALGOS:-rsa ed25519 ecdsa}"

echo 'host key fingerprints'
echo '==='
for algo in ${host_key_algos}; do gen_host_key ${algo}; done
echo '==='
echo

exec /usr/sbin/sshd -eDf/var/sshd/config
EOF

RUN chmod +x /bin/container-entrypoint.sh

RUN adduser \
    -h/var/sshd \
    -s/sbin/nologin \
    -D \
    ssh-daemon

COPY <<EOF /var/sshd/config
Include /var/sshd/config.d/*.conf
Port 8022

HostKey /var/sshd/keys/host_rsa_key
HostKey /var/sshd/keys/host_ecdsa_key
HostKey /var/sshd/keys/host_ed25519_key

PermitRootLogin no
AuthorizedKeysFile keys/authorized_keys
PidFile /var/sshd/sshd.pid
EOF

RUN mkdir \
      /var/sshd/config.d /var/sshd/keys \
    && \
    chown -R ssh-daemon:ssh-daemon \
      /var/sshd/

USER ssh-daemon
ENTRYPOINT ["/bin/container-entrypoint.sh"]
