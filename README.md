# X11 Docker (lite)

_**Disclaimer:** This project is not related to [x11docker](https://github.com/mviereck/x11docker)_

I use this project to test GUI applications in different distribution/desktop version combinations.

Images are added as needed. Pull requests for other distros and commonly used libraries are very welcome!


## Supported tags (distro version, desktop)

- `focal-gnome3`
- `bionic-gnome3`
- `xenial-unity7`

## Extending with additional software

    # Dockerfile
    FROM darkdragon001/x11:focal-gnome3
    
    # Install gedit
    RUN apt-get update && apt-get install -y \
          gedit && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

## Installation

Add this to your .bashrc file

    function dx {  # docker X11
        XSOCK=/tmp/.X11-unix
        XAUTH=/tmp/.docker.xauth
        touch ${XAUTH}
        xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -
        docker run -it --rm -e DISPLAY -v ${XSOCK}:${XSOCK} -v ${XAUTH}:${XAUTH}:rw -e XAUTHORITY=${XAUTH} --ipc=host --tmpfs /tmp --user $(id -u):$(id -g) $@
    }

Apply with `exec bash`.

### Mac OSX or Windows

They don't ship with an X11 server, thus separate software must be installed. Follow [this guide](https://techsparx.com/software-development/docker/display-x11-apps.html) and adapt the `dx` function above according to the guide.


## Examples

Build image:

    docker build -t darkdragon001/x11:focal-gnome3 -f Dockerfile .

Run your application:

    dx --name mycontainer -v "$(pwd)":"/home/default/app" darkdragon001/x11:focal-gnome3 ./app/executable

Open an additional shell as the current user:

    dxx mycontainer bash

or as another user _(`root` with `UID=0` is also possible)_:

    dxxu mycontainer 999:999 bash

