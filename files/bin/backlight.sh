#!/bin/sh
#
# useful script for backlight
#

usage()
{
        printf "\033[1musage:\033[0m %s [get|up|down|set] N%%\n" "$0"
        printf "\tget\t\t\033[3mPrint current brightness percent\033[0m\n"
        printf "\tup N\t\t\033[3mIncrease brightness by N percent\033[0m\n"
        printf "\tdown N\t\t\033[3mDecrease brightness by N percent\033[0m\n"
        printf "\tset N\t\t\033[3mSet brightness to N percent (0-100)\033[0m\n"
        printf "\n\033[1m\033[91mWarning:\033[0m (or not really) if you have multiple backlights (multimonitor) then this script isn't for you.\n"
        printf "\tConsider alternatives such as brightnessctl\n"
}

perms()
{
        printf "\033[91mPermission error:\033[0m Cannot access \`/sys/class/backlight/*/brightness\`"
        printf "\nPlease set the perms to allow video group to access \`/sys/class/backlight/*/brightness\`:\n"
        printf "\tchgrp video /sys/class/backlight/*/brightness\n"
        printf "\tchmod 0660 /sys/class/backlight/*/brightness\n"
        printf "\n\033[3mOptionally, you can set a udev/mdev rule to do this at boot (which is recommended)\033[0m\n"
}

# only finds the first one, which is why it's not recommended for multi-display setups
find_backlight()
{
        for d in /sys/class/backlight/*; do
                [ -e "$d" ] || continue
                if [ -r "$d/max_brightness" ] && [ -w "$d/brightness" ]; then
                        printf '%s\n' "$d"
                        return 0
                fi
        done
        return 1
}

dev=$(find_backlight) || {
        perms
        exit 2
}
bright_file="$dev/brightness"
max_file="$dev/max_brightness" 

read_file() {
        if [ ! -r "$1" ]; then
                usage
                exit 1
        fi
        IFS= read -r val <"$1" || return 1

        case "$val" in
                ''|*[!0-9]) return 1 ;;
                *) printf '%s\n' "$val" ;;
        esac
}

# max brightness in int
max=$(read_file "$max_file") || {
        printf '\033[91merror:\033[0m cannot read max_brightness\n' >&2
        exit 3
}
# current brightness in int
cur_int=$(read_file "$bright_file") || {
        printf '\033[91merror:\033[0m cannot read brightness\n' >&2
        exit 3
}

int_to_perc()
{
        int=$1
        printf '%s\n' $(( (int * 100 + max/2) / max ))
}

perc_to_int()
{
        p=$1
        if [ "$p" -le 0 ]; then
                printf '0\n'
                return
        fi
        if [ "$p" -ge 100 ]; then
                printf '%s\n' "$max"
                return
        fi
        printf '%s\n' $(( (p * max + 50) / 100 ))
}

cmd=${1:-}
case "$cmd" in
        get)
                int_to_perc "$cur_int"
                exit 0
                ;;
        up|down|set)
                if [ -z "${2:-}" ]; then
                        usage
                        exit 1
                fi
                case "$2" in
                        ''|*[!0-9]) printf '\033[91merror:\033[0m N must be a non-negative integer\n' >&2; exit 1 ;;
                esac
                n=$2
                ;;
        *)
                usage
                exit 1
                ;;
esac

# grab the current brightness
cur_perc=$(int_to_perc "$cur_int")

case "$cmd" in
        set)  target_perc=$n ;;
        up)   target_perc=$(( cur_perc + n )) ;;
        down) target_perc=$(( cur_perc - n )) ;;
esac

# ensure values are never less than 0 or greater than 100
if [ "$target_perc" -lt 0 ]; then target_perc=0; fi
if [ "$target_perc" -gt 100 ]; then target_perc=100; fi

target_int=$(perc_to_int "$target_perc") || {
        printf '\033[91merror:\033[0m failed to compute target value\n' >&2
        exit 4
}

if printf '%s' "$target_int" > "$bright_file"; then
        printf '\033[1;32mok:\033[0m brightness set to %s%% (%s/%s)\n' "$target_perc" "$target_int" "$max"
        exit 0
else
        perms
        exit 5
fi
