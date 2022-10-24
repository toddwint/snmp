# toddwint/snmp

## Info

`snmp` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/snmp>

GitHub: <https://github.com/toddwint/snmp>


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

# The IP subnet in the form subnet/cidr
SUBNET=192.168.10.0/24

# SNMP user details (up to 5 users)
# The ENGINE ID of the remote SNMP device
# The username
# The authentication phrase and hash algorithm
# The privacy phrase and encryption algorithm
SNMPUSER1ENGINID=0x0102030405
SNMPUSER1USRNAME=user1
SNMPUSER1AUTHALG=SHA
SNMPUSER1AUTHPHR=authphrase1
SNMPUSER1PRIVALG=AES
SNMPUSER1PRIVPHR=privacyphrase1
SNMPUSER2ENGINID=0x0102030405
SNMPUSER2USRNAME=user2
SNMPUSER2AUTHALG=SHA
SNMPUSER2AUTHPHR=authphrase2
SNMPUSER2PRIVALG=AES
SNMPUSER2PRIVPHR=privacyphrase2
SNMPUSER3ENGINID=0x0102030405
SNMPUSER3USRNAME=user3
SNMPUSER3AUTHALG=SHA
SNMPUSER3AUTHPHR=authphrase3
SNMPUSER3PRIVALG=AES
SNMPUSER3PRIVPHR=privacyphrase3
SNMPUSER4ENGINID=0x0102030405
SNMPUSER4USRNAME=user4
SNMPUSER4AUTHALG=SHA
SNMPUSER4AUTHPHR=authphrase4
SNMPUSER4PRIVALG=AES
SNMPUSER4PRIVPHR=privacyphrase4
SNMPUSER5ENGINID=0x0102030405
SNMPUSER5USRNAME=user5
SNMPUSER5AUTHALG=SHA
SNMPUSER5AUTHPHR=authphrase5
SNMPUSER5PRIVALG=AES
SNMPUSER5PRIVPHR=privacyphrase5

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
source "$(dirname "$(realpath $0)")"/config.txt

# Set the IP on the interface
IPASSIGNED=$(ip addr show $INTERFACE | grep $IPADDR)
if [ -z "$IPASSIGNED" ]; then
   SETIP="$IPADDR/$(echo $SUBNET | awk -F/ '{print $2}')" 
   sudo ip addr add $SETIP dev $INTERFACE
else
    echo 'IP is already assigned to the interface'
fi

# Create the docker container
docker run -dit \
    --name "$HOSTNAME" \
    -h "$HOSTNAME" \
    -p $IPADDR:161:161/udp \
    -p $IPADDR:161:161/tcp \
    -p $IPADDR:162:162/udp \
    -p $IPADDR:162:162/tcp \
    -p "$IPADDR":"$HTTPPORT1":"$HTTPPORT1" \
    -p "$IPADDR":"$HTTPPORT2":"$HTTPPORT2" \
    -p "$IPADDR":"$HTTPPORT3":"$HTTPPORT3" \
    -p "$IPADDR":"$HTTPPORT4":"$HTTPPORT4" \
    -e TZ="$TZ" \
    -e SNMPUSER1ENGINID=$SNMPUSER1ENGINID \
    -e SNMPUSER1USRNAME=$SNMPUSER1USRNAME \
    -e SNMPUSER1AUTHALG=$SNMPUSER1AUTHALG \
    -e SNMPUSER1AUTHPHR=$SNMPUSER1AUTHPHR \
    -e SNMPUSER1PRIVALG=$SNMPUSER1PRIVALG \
    -e SNMPUSER1PRIVPHR=$SNMPUSER1PRIVPHR \
    -e SNMPUSER2ENGINID=$SNMPUSER2ENGINID \
    -e SNMPUSER2USRNAME=$SNMPUSER2USRNAME \
    -e SNMPUSER2AUTHALG=$SNMPUSER2AUTHALG \
    -e SNMPUSER2AUTHPHR=$SNMPUSER2AUTHPHR \
    -e SNMPUSER2PRIVALG=$SNMPUSER2PRIVALG \
    -e SNMPUSER2PRIVPHR=$SNMPUSER2PRIVPHR \
    -e SNMPUSER3ENGINID=$SNMPUSER3ENGINID \
    -e SNMPUSER3USRNAME=$SNMPUSER3USRNAME \
    -e SNMPUSER3AUTHALG=$SNMPUSER3AUTHALG \
    -e SNMPUSER3AUTHPHR=$SNMPUSER3AUTHPHR \
    -e SNMPUSER3PRIVALG=$SNMPUSER3PRIVALG \
    -e SNMPUSER3PRIVPHR=$SNMPUSER3PRIVPHR \
    -e SNMPUSER4ENGINID=$SNMPUSER4ENGINID \
    -e SNMPUSER4USRNAME=$SNMPUSER4USRNAME \
    -e SNMPUSER4AUTHALG=$SNMPUSER4AUTHALG \
    -e SNMPUSER4AUTHPHR=$SNMPUSER4AUTHPHR \
    -e SNMPUSER4PRIVALG=$SNMPUSER4PRIVALG \
    -e SNMPUSER4PRIVPHR=$SNMPUSER4PRIVPHR \
    -e SNMPUSER5ENGINID=$SNMPUSER5ENGINID \
    -e SNMPUSER5USRNAME=$SNMPUSER5USRNAME \
    -e SNMPUSER5AUTHALG=$SNMPUSER5AUTHALG \
    -e SNMPUSER5AUTHPHR=$SNMPUSER5AUTHPHR \
    -e SNMPUSER5PRIVALG=$SNMPUSER5PRIVALG \
    -e SNMPUSER5PRIVPHR=$SNMPUSER5PRIVPHR \
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
