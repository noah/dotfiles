#!/bin/sh
/home/noah/bin/riddim -q | grep "^\* " | sed "s/.*\]\s*//" | tr -d '\n'
