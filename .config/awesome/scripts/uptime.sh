#!/bin/sh

echo -n $(/usr/bin/uptime | cut -d ' ' -f 3-)
