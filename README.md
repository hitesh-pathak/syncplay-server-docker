# README

## What is this about

- Get syncplay server running on a VM
- Use container to deploy it so it is easily reused

## Creating the container

The idea is to create an image, using docker file, although we'll be using Podman here instead as it's a lighter alternative, and that matters on the server.

### Installing syncplay in container

[Official syncplay guide](https://syncplay.pl/guide/install/)

We'll be using Alpine image for this and we need to figure out what dependencies we need to install. T

The above guide gives us a bunch of python packages (particularly for TLS).
However we want to use the distro's packages for better compatibility.

Package index to find distro packages - [link](https://pkgs.alpinelinux.org/packages)

#### Dependencies, we'll use:

- `twisted` -> `py3-twisted`
- `certifi` -> `py3-certifi`
- `pyopenssl` -> `py3-openssl`
- `service_identity` -> `py3-service_identity`
- `idna` -> `py3-idna`
- `pem` -> `py3-pem`


```sh
apk add --no-cache --update --progress \
        curl \
        make \
        py3-twisted \
        py3-certifi \
        py3-openssl \
        py3-service_identity \
        py3-idna \
        py3-pem
```
#### Installing with pip anyway...

Turns out, it did not go well with distro packages, mainly because some dependencies where not available for python to import.

Syncplay basically installs as a set of python packages, and it imports the dependencies, which means that those dependencies need to be installed in a way that system python can find them.

For some reason, the alpine distro package installation did not work out well for this

```sh
pip3 install --upgrade pip && \
pip3 install \
    twisted \
    certifi \
    pyopenssl \
    service_identity \
    idna \
    pem
```

Still need to install some pkgs for building

```sh
apk add --no-cache --update --progress \
make \
curl
```

#### Downloading and installing syncplay server

Get the release from github, download in a temp location

```sh
SYNCPLAY_VER=1.7.4
mkdir -p /tmp/syncplay-build && cd /tmp/syncplay-build
```

```sh
curl -L -o syncplay.tar.gz \
  https://github.com/Syncplay/syncplay/archive/refs/tags/v${SYNCPLAY_VER}.tar.gz
```

Extract and install the server part only

```sh
tar -xzf syncplay.tar.gz && cd syncplay-${SYNCPLAY_VER}
```
```sh
make install-server
```

Now the server should be installed, and we can verify with:

```sh
syncplay-server --help

## run
syncplay-server
```

## Containerizing the fiasco

Now that we've got our hands dirty with the manual part, we can containerize the process

- [dockerfile](./dockerfile)
- [entrypoint script](./entrypoint.sh)
- [docker compose file](./docker-compose.yml)

How to build and run the server

```sh
podman compose up --build -d
```

Observe the logs
```sh
podman logs syncplay-server -f
```




