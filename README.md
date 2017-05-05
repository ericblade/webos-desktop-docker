# webos-desktop-docker

Working out a Dockerfile configuration that will allow one to build Open webOS (and in the future,
LuneOS, perhaps?) for desktop using Docker

Intent is to create a Docker container with which you can see (and develop) Open webOS on any
desktop with X11 and Docker support.

Initial version just pulls in all the dependencies from github.com/openwebos/build-desktop, and
builds it inside a docker container using a slightly modified version of the original build process.

That is likely not very efficient of a method for using Docker, and Docker can do this better.
So, future updates will attempt to make a better Docker environment than the existing build-webos
scripts provide.

# To run

docker build -t webos .
(replace 192.168.0.1 with your IP address below)
docker run --security-opt seccomp=unconfined -e DISPLAY=192.168.0.1:0.0 -e QT_GRAPHICSSYSTEM=native -i -t webos /bin/bash

# Note
This crashes with a failure in xcb attempting to enumerate displays.  Not sure why. Not sure if can be fixed.

