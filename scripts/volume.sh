#!/bin/sh
#
# useful volume script
#

usage()
{
        echo 'usage: volume.sh up|down|tog'
}

case "$1" in
        up) amixer set Master 5%+ unmute ;;
        down) amixer set Master 5%- ;;
        tog) amixer set Master toggle ;;
        *) usage ;;
esac
