# sshd

Dockerfile and company to spin up lightweight sshd containers

> **Warning**
> **CAVEAT**: this image at the current version is not intended to
> provide shell access. But "proxy" connections to other
> ssh servers.

## Using the image

Well there is no image yet. I have not published to any registry.
You will need to build it yourself.

```shell
git clone https://github.com/kevinnls/docker-sshd.git --depth=1
cd docker-sshd
docker buildx build -t sshd .
docker run \
    -p 22:8022
    -v sshd_keys:/var/sshd/keys
    -v sshd_config:/var/sshd/config.d:ro #optional
```

### sshd Port
The container's ssh daemon listens on port `8022` to
avoid running as root. You may however map the internal port
to any external port you choose on the host.

The `-p`/`--publish` flag accomplishes this e.g  `docker run -p 22:8022`

Refer: https://docs.docker.com/config/containers/container-networking/

### Host Keys
The container created from the image generates new
[host keys](https://www.ssh.com/academy/ssh/host-key)
at its initialisation. This is done to ensure that each
container's keys is unique. If the keys were part of the
image, the ssh client would see any container based on the
image as the same host.

You may want to persist the keys by using a bindmount
or a volume.

Refer: https://docs.docker.com/storage/bind-mounts/
Refer: https://docs.docker.com/storage/volumes/

#### Custom Keys
If you are bringing your own keys (e.g. to horizontally
scale ssh servers), you still need to use the same path
`/var/sshd/keys` in the container.

Host key files are to be named as follows
```
host_rsa_key
host_ecdsa_key
host_ed25519_key
```

### `authorized_keys` File
Is read from `/var/sshd/keys/authorized_keys`

### Additional Configuration Options
Custom configuration options than the defaults may be specified using files
ending in `.conf` mounted at the `/var/sshd/config.d` directory.

For information on mounting volumes or binding folders from the host, refer:
- https://docs.docker.com/storage/bind-mounts/
- https://docs.docker.com/storage/volumes/
