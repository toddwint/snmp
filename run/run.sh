#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name snmp \
    -p $IPADDR:161:161/udp \
    -p $IPADDR:162:162/udp \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v snmp:/var/log/snmp \
    -e TZ=$TZ \
    --cap-add=NET_ADMIN \
    toddwint/snmp
