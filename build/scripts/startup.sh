#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

snmptrapd -A -a -tLf /var/log/snmp/snmptrapd.log
frontail -d -p $HTTPPORT /var/log/snmp/snmptrapd.log

# Keep docker running
bash
