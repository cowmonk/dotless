#!/bin/sh
#
# useful volume script
# 

usage()
{
        printf '\033[1mUsage: \033[0m%s [up|down|set|tog] N%%\n' "$0"
        printf '\tup N\t\t\033[3mIncrease volume by N (e.g. %s up 5)\033[0m\n' "$0"
        printf '\tdown N\t\t\033[3mDecrease volume by N\033[0m\n'
        printf '\tset N\t\t\033[3mSet volume to N (0-100)\033[0m\n'
        printf '\ttog\t\t\033[3mToggle mute\033[0m\n'
}

case "$1" in
        up)   amixer set Master ${2}%+ unmute ;;
        down) amixer set Master ${2}%- ;;
        tog)  amixer set Master toggle ;;
        set)  amixer set Master ${2}% ;;
        *)    usage ;;
esac
