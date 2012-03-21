#!/bin/sh

echo -n "$(/usr/bin/yaourt -Qu|wc -l|tr '\n' ' ')updates available ($(date -d"@$(stat -c '%X' /var/lib/pacman/sync/archlinuxfr.db)" +"%a %b %d, %H:%M"))"
