#!/bin/sh

echo -n "$(/usr/bin/yaourt -Qu|wc -l|tr '\n' ' ')updates available"
