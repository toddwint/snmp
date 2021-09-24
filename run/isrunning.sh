#!/usr/bin/env bash
running=$(docker ps | grep snmp | wc -l)
if [ $running -eq 1 ]
then
    echo "Yes. It is running. Look:  "
    docker ps | grep snmp
else
    echo "He's dead Jim."
fi
