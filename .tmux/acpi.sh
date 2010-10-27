#!/bin/sh
# Battery 0: Discharging, 40%, 01:29:58 remaining
acpi|sed -r 's#Battery 0[^0-9]+([0-9]+%)[^0-9]*(([0-9]*:?){3}).*#\1 (\2)#'
