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
	ssh-keygen -N '' -qf"${path}" ${args}
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
