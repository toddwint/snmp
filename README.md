# toddwint/snmp

## Info

`snmp` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/snmp>

GitHub: <https://github.com/toddwint/snmp>


## Overview

- Download the docker image and github files.
- Configure the settings in `run/config.txt`.
- Start a new container by running `run/create_container.sh`. 
  - The folder `upload` will be created as specified in the `create_container.sh` script.
  - An example CSV file `snmp_users.csv` is created in the `upload` volume on the first run.
- Fill in the file `upload/snmp_users.csv`.
  - Modify it as you need, and place it back in the same folder with the same name.
  - Additional columns can be added after the last column
- Trigger the container to update by restarting it with `./restart.sh` or `./stop.sh` and `./start.sh`. 
  - You can also run `./delete_container` followed by `./create_container` as the `upload` folder will not be removed automatically.
- Open the file webadmin.html to view messages in a web browser.


## Features

- Ubuntu base image
- Plus:
  - snmp-mibs-downloader
  - snmptrapd
  - snmp
  - libsnmp-dev
  - tmux
  - python3-minimal
  - iproute2
  - tzdata
  - [ttyd](https://github.com/tsl0922/ttyd)
    - View the terminal in your browser
  - [frontail](https://github.com/mthenw/frontail)
    - View logs in your browser
    - Mark/Highlight logs
    - Pause logs
    - Filter logs
  - [tailon](https://github.com/gvalkov/tailon)
    - View multiple logs and files in your browser
    - User selectable `tail`, `grep`, `sed`, and `awk` commands
    - Filter logs and files
    - Download logs to your computer


## Sample `config.txt` file

```
# To get a list of timezones view the files in `/usr/share/zoneinfo`
TZ=UTC

# The interface on which to set the IP. Run `ip -br a` to see a list
INTERFACE=eth0

# The IP address that will be set on the host and NAT'd to the container
IPADDR=192.168.10.1

# The IP subnet in the form NETWORK/PREFIX
SUBNET=192.168.10.0/24

# The IP of the gateway
GATEWAY=192.168.10.254

# Add any custom routes needed in the form NETWORK/PREFIX
# Separate multiple routes with a comma
# Example: 10.0.0.0/8,192.168.0.0/16
ROUTES=0.0.0.0/0

# The ports for web management access of the docker container.
# ttyd tail, ttyd tmux, frontail, and tmux respectively
HTTPPORT1=8080
HTTPPORT2=8081
HTTPPORT3=8082
HTTPPORT4=8083

# The hostname of the instance of the docker container
HOSTNAME=snmp01
```


## Sample docker run script

```
#!/usr/bin/env bash
REPO=toddwint
APPNAME=snmp
HUID=$(id -u)
HGID=$(id -g)
SCRIPTDIR="$(dirname "$(realpath "$0")")"
source "$SCRIPTDIR"/config.txt

# Set the IP on the interface
IPASSIGNED=$(ip addr show $INTERFACE | grep $IPADDR)
if [ -z "$IPASSIGNED" ]; then
   SETIP="$IPADDR/$(echo $SUBNET | awk -F/ '{print $2}')" 
   sudo ip addr add $SETIP dev $INTERFACE
else
    echo 'IP is already assigned to the interface'
fi

# Add remote network routes
IFS=',' # Internal Field Separator
for ROUTE in $ROUTES; do sudo ip route add "$ROUTE" via "$GATEWAY"; done

# Create the docker container
docker run -dit \
    --name "$HOSTNAME" \
    -h "$HOSTNAME" \
    ` # Volume can be changed to another folder. For Example: ` \
    ` # -v /home/"$USER"/Desktop/upload:/opt/"$APPNAME"/upload \ ` \
    -v "$SCRIPTDIR"/upload:/opt/"$APPNAME"/upload \
    -p $IPADDR:161:161/udp \
    -p $IPADDR:161:161/tcp \
    -p $IPADDR:162:162/udp \
    -p $IPADDR:162:162/tcp \
    -p "$IPADDR":"$HTTPPORT1":"$HTTPPORT1" \
    -p "$IPADDR":"$HTTPPORT2":"$HTTPPORT2" \
    -p "$IPADDR":"$HTTPPORT3":"$HTTPPORT3" \
    -p "$IPADDR":"$HTTPPORT4":"$HTTPPORT4" \
    -e TZ="$TZ" \
    -e HUID="$HUID" \
    -e HGID="$HGID" \
    -e HTTPPORT1="$HTTPPORT1" \
    -e HTTPPORT2="$HTTPPORT2" \
    -e HTTPPORT3="$HTTPPORT3" \
    -e HTTPPORT4="$HTTPPORT4" \
    -e HOSTNAME="$HOSTNAME" \
    -e APPNAME="$APPNAME" \
    ${REPO}/${APPNAME}
```


## Login page

Open the `webadmin.html` file.

- Or just type in your browser: 
  - `http://<ip_address>:<port1>` or
  - `http://<ip_address>:<port2>` or
  - `http://<ip_address>:<port3>`
  - `http://<ip_address>:<port4>`
