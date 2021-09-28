# toddwint/snmp

## Info

<https://hub.docker.com/r/toddwint/snmp>

<https://github.com/toddwint/snmp>

SNMP server docker image for simple lab SNMP testing.

This image was created for lab setups where the need to verify SNMP messages are being sent to a customer owned SNMP server.


## Features

- Receive SNMP messages from clients.
- View remote SNMP messages in a web browser ([frontail](https://github.com/mthenw/frontail))
    - tail the file
    - pause the flow
    - search through the flow
    - highlight multiple rows
- SNMP messages are persistent if you map the directory `/var/log/snmp `


## Sample `config.txt` file

```
TZ=UTC
IPADDR=127.0.0.1
HTTPPORT=9001
HOSTNAME=snmpsrvr
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
```

## Sample docker run command

```
#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name snmp \
    -h $HOSTNAME \
    -p $IPADDR:161:161/udp \
    -p $IPADDR:161:161/tcp \
    -p $IPADDR:162:162/udp \
    -p $IPADDR:162:162/tcp \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v snmp:/var/log/snmp \
    -e TZ=$TZ \
    -e HOSTNAME=$HOSTNAME \
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
    --cap-add=NET_ADMIN \
    toddwint/snmp
```

## Sample webadmin.html.template file

See my github page (referenced above).


## Login page

Open the `webadmin.html` file.

Or just type in your browser `http://<ip_address>:<port>`


## Issues?

Make sure if you set an IP that machine has the same IP configured on an interface.
