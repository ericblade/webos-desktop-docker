# TODO: LunaUniversalSearchMgr needs to have some bad casts around line 225 in OpenSearchsomething.c patched out
# TODO: Something is still going wrong with service-bus.sh init, it works when i run it manually from command line, but not from docker ?
# TODO: sadly, LunaSysMgr is still blowing up on the attempt to figure out the display.

FROM ubuntu:12.04
MAINTAINER Eric Blade <blade.eric@gmail.com>
WORKDIR /root

RUN apt-get update && apt-get install -y wget git git-core pkg-config make autoconf libtool g++ tcl unzip \
libyajl-dev libyajl1 qt4-qmake libsqlite3-dev curl gperf bison libglib2.0-dev libssl-dev libxi-dev \
libxrandr-dev libxfixes-dev libxcursor-dev libfreetype6-dev libxinerama-dev libgl1-mesa-dev \
libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev flex libicu-dev libboost-system-dev \
libboost-filesystem-dev libboost-regex-dev libboost-program-options-dev liburiparser-dev \
libc-ares-dev libsigc++-2.0-dev libglibmm-2.4-dev libdb4.8-dev libcurl4-openssl-dev xcb \
libx11-xcb-dev libxcb-sync0-dev libxcb1-dev libxcb-keysyms1-dev libxcb-image0-dev \
libxcb-render-util0-dev libxcb-icccm4-dev

# vim-common is for xxd, which is used in node-addon-pmlog
RUN apt-get install -y psmisc sudo vim-common gdb
RUN update-alternatives --install /bin/sh sh /bin/bash 100

RUN apt-get install -y cmake

RUN export uid=1000 gid=1000 && \
    mkdir -p /etc/sudoers.d && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

WORKDIR /home/developer

RUN git clone https://github.com/openwebos/build-desktop.git
WORKDIR /home/developer/build-desktop
COPY build-component.sh /home/developer/build-desktop/build-component.sh

ARG luna_sysmgr=5
ENV LSM_TAG=$luna_sysmgr

RUN ./build-component.sh cmake

ARG cmake_modules_webos=19
RUN ./build-component.sh cmake-modules-webos $cmake_modules_webos

ARG qt4=4
RUN ./build-component.sh qt4 $qt4

ARG npapi_headers=0.4
RUN ./build-component.sh npapi-headers $npapi_headers

ARG luna_webkit_api=1.01
RUN ./build-component.sh luna-webkit-api $luna_webkit_api

ARG cjson=35
RUN ./build-component.sh cjson $cjson

ARG pmloglib=21
RUN ./build-component.sh pmloglib $pmloglib

ARG luna_service2=147
RUN ./build-component.sh luna-service2 $luna_service2

ARG webkit=0.54
RUN ./build-component.sh webkit $webkit

ARG pbnjson=7
RUN ./build-component.sh pbnjson $pbnjson

ARG nyx_lib=58
RUN ./build-component.sh nyx-lib $nyx_lib

ARG luna_sysmgr_ipc=2
RUN ./build-component.sh luna-sysmgr-ipc $luna_sysmgr_ipc

ARG luna_sysmgr_ipc_messages=2
RUN ./build-component.sh luna-sysmgr-ipc-messages $luna_sysmgr_ipc_messages

ARG luna_sysmgr_common=4
RUN ./build-component.sh luna-sysmgr-common $luna_sysmgr_common

RUN ./build-component.sh luna-sysmgr $luna_sysmgr

ARG keyboard_efigs=1.02
RUN ./build-component.sh keyboard-efigs $keyboard_efigs

ARG webappmanager=4
RUN ./build-component.sh webappmanager $webappmanager

ARG luna_init=1.03
RUN ./build-component.sh luna-init $luna_init

ARG luna_prefs=1.01
RUN ./build-component.sh luna-prefs $luna_prefs

ARG luna_sysservice=2
RUN ./build-component.sh luna-sysservice $luna_sysservice

ARG librolegen=16
RUN ./build-component.sh librolegen $librolegen

# TODO: LunaUniversalSearchMgr is not installed?!
ARG luna_universalsearchmgr=3
RUN sleep 6 && ./build-component.sh luna-universalsearchmgr $luna_universalsearchmgr && sleep 90

ARG luna_applauncher=1.00
RUN ./build-component.sh luna-applauncher $luna_applauncher

ARG luna_systemui=1.02
RUN ./build-component.sh luna-systemui $luna_systemui

ARG enyo_1=128.2
RUN ./build-component.sh enyo-1.0 $enyo_1

ARG core_apps=2
RUN ./build-component.sh core-apps $core_apps

ARG isis_browser=0.21
RUN ./build-component.sh isis-browser $isis_browser

ARG isis_fonts=v0.1
RUN ./build-component.sh isis-fonts $isis_fonts

ARG foundation_frameworks=1.0
RUN ./build-component.sh foundation-frameworks $foundation_frameworks

ARG mojoservice_frameworks=1.0
RUN ./build-component.sh mojoservice-frameworks $mojoservice_frameworks

ARG loadable_frameworks=1.0.1
RUN ./build-component.sh loadable-frameworks $loadable_frameworks

ARG app_services=1.02
RUN ./build-component.sh app-services $app_services

ARG mojolocation_stub=2
RUN ./build-component.sh mojolocation-stub $mojolocation_stub

ARG pmnetconfigmanager_stub=3
RUN ./build-component.sh pmnetconfigmanager-stub $pmnetconfigmanager_stub

ARG underscore=8
RUN ./build-component.sh underscore $underscore

ARG mojoloader=8
RUN ./build-component.sh mojoloader $mojoloader

ARG mojoservicelauncher=71
RUN ./build-component.sh mojoservicelauncher $mojoservicelauncher

ARG WebKitSupplemental=0.4
RUN ./build-component.sh WebKitSupplemental $WebKitSupplemental

ARG AdapterBase=0.2
RUN ./build-component.sh AdapterBase $AdapterBase

ARG BrowserServer=0.7.1
RUN ./build-component.sh BrowserServer $BrowserServer

ARG BrowserAdapter=0.4.1
RUN ./build-component.sh BrowserAdapter $BrowserAdapter

ARG nodejs=34
RUN ./build-component.sh nodejs $nodejs

ARG node_addon_sysbus=25
RUN ./build-component.sh node-addon sysbus 25

ARG node_addon_pmlog=10
RUN ./build-component.sh node-addon pmlog $node_addon_pmlog

ARG node_addon_dynaload=11
RUN ./build-component.sh node-addon dynaload $node_addon_dynaload

ARG leveldb=1.9
RUN ./build-component.sh leveldb $leveldb

ARG db8=63
RUN ./build-component.sh db8 $db8

ARG configurator=49
RUN ./build-component.sh configurator $configurator

ARG activitymanager=110
RUN ./build-component.sh activitymanager $activitymanager

ARG pmstatemachineengine=13
RUN ./build-component.sh pmstatemachineengine $pmstatemachineengine

ARG libpalmsocket=30
RUN ./build-component.sh libpalmsocket $libpalmsocket

ARG libsandbox=15
RUN ./build-component.sh libsandbox $libsandbox

ARG jemalloc=11
RUN ./build-component.sh jemalloc $jemalloc

ARG filecache=55
RUN ./build-component.sh filecache $filecache

ARG mojomail=99
RUN ./build-component.sh mojomail $mojomail

USER root
# TODO: add psmisc, sudo, vim-common to top apt-get
# RUN cp -f /home/developer/build-desktop/ls2/* /home/developer/luna-desktop-binaries/staging/etc/luna-service2/
RUN ./install-webos-desktop.sh
# RUN find / -print | grep package.json
# RUN find /home/developer/luna-desktop-binaries -print | grep node

# RUN mkdir -p /usr/share/ls2/system-services && mkdir -p /usr/share/ls2/roles/prv && mkdir -p /usr/share/ls2/services && mkdir -p /usr/share/ls2/roles/pub && mkdir -p /usr/lib/luna
# RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/share/ls2 /usr/share/ls2
# RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/lib/luna /usr/lib/luna
# RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/etc/palm /etc/palm
# RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/palm /usr/palm

# RUN find ../luna-desktop-binaries -print | grep filecache
#RUN ls ../luna-desktop-binaries/rootfs/usr/lib/luna
#RUN ls /usr/lib/luna
#RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/lib/luna/filecache /usr/lib/luna/filecache
#RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/lib/luna/mojodb-luna /usr/lib/luna/mojodb-luna
#RUN ln -sf /home/developer/luna-desktop-binaries/rootfs/usr/lib/luna/LunaSysService /usr/lib/luna/LunaSysService
# RUN ls -al /usr/lib/luna

USER developer

# RUN sudo mount / -o remount,user_xattr && ./service-bus.sh start && sleep 2 && ./service-bus.sh init && sleep 10
# CMD sudo mount / -o remount,user_xattr && ./service-bus.sh start && sleep 2 && ./service-bus.sh services && sleep 10 && ./run-luna-sysmgr.sh
# mount errors with "mount: permission denied" so apparently we can't get the user_xattr field set. possibly might need to do it at the VM or OS level?

# due to errors that occur in the initial init process, must re-run it a second time. argh.
RUN ./service-bus.sh start && ./service-bus.sh init

#RUN ./service-bus.sh start && sleep 5 && ./service-bus.sh init && sleep 60; exit 0
#RUN ./service-bus.sh start && sleep 5 && ./service-bus.sh init && sleep 60; exit 0
CMD ./service-bus.sh start && sleep 2 && ./service-bus.sh services && sleep 10 && ./run-luna-sysmgr.sh
