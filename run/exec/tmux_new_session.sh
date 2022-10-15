#!/usr/bin/env bash
APPNAME=snmp
source "$(dirname "$(dirname "$(realpath $0)")")"/config.txt
docker exec -it -w /opt/"$APPNAME"/scripts "$HOSTNAME" ./tmux.sh
