#!/bin/bash

sudo apt-get install tightvncserver

sudo cat > /etc/network/interfaces <<- EOI
face usb0 inet static
address 192.168.42.42
netmask 255.255.255.0
network 192.168.42.0
broadcast 192.168.42.255
EOI

sudo cat > /etc/init.d/vncboot <<- EOV
#! /bin/sh
### BEGIN INIT INFO
# Provides:          vncboot
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Run tightvnc on boot
### END INIT INFO
 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin
export USER='pi'
 
eval cd ~$USER
 
. /lib/init/vars.sh
. /lib/lsb/init-functions
 
case "$1" in
  start)
    log_begin_msg "Starting VNC server"
    su $USER -c '/usr/bin/vncserver :1 -geometry 1680x1050 -depth 24'
    log_end_msg $?
    exit 0
    ;;
  stop)
    pkill Xtightvnc
    log_begin_msg "Stopping VNC server"
    log_end_msg $?
    exit 0
    ;;
  *)
    echo "Usage: /etc/init.d/vncboot {start|stop}"
    exit 1
    ;;
esac
EOV

sudo chmod +X /etc/init.d/vncboot 
sudo update-rc.d vncboot defaults
