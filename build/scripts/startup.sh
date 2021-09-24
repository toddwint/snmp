#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# SNMPUSER1
if [ -n "$SNMPUSER1USRNAME" ] && [ -n "$SNMPUSER1ENGINID" ]
then
   echo "createUser -e $SNMPUSER1ENGINID $SNMPUSER1USRNAME $SNMPUSER1AUTHALG $SNMPUSER1AUTHPHR $SNMPUSER1PRIVALG $SNMPUSER1PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER1USRNAME" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER1USRNAME" ]
then
    echo "createUser $SNMPUSER1USRNAME $SNMPUSER1AUTHALG $SNMPUSER1AUTHPHR $SNMPUSER1PRIVALG $SNMPUSER1PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER1USRNAME" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER2
if [ -n "$SNMPUSER2USRNAME" ] && [ -n "$SNMPUSER2ENGINID" ]
then
   echo "createUser -e $SNMPUSER2ENGINID $SNMPUSER2USRNAME $SNMPUSER2AUTHALG $SNMPUSER2AUTHPHR $SNMPUSER2PRIVALG $SNMPUSER2PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER2USRNAME" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER2USRNAME" ]
then
    echo "createUser $SNMPUSER2USRNAME $SNMPUSER2AUTHALG $SNMPUSER2AUTHPHR $SNMPUSER2PRIVALG $SNMPUSER2PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER2USRNAME" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER3
if [ -n "$SNMPUSER3USRNAME" ] && [ -n "$SNMPUSER3ENGINID" ]
then
   echo "createUser -e $SNMPUSER3ENGINID $SNMPUSER3USRNAME $SNMPUSER3AUTHALG $SNMPUSER3AUTHPHR $SNMPUSER3PRIVALG $SNMPUSER3PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER3USRNAME" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER3USRNAME" ]
then
    echo "createUser $SNMPUSER3USRNAME $SNMPUSER3AUTHALG $SNMPUSER3AUTHPHR $SNMPUSER3PRIVALG $SNMPUSER3PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER3USRNAME" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER4
if [ -n "$SNMPUSER4USRNAME" ] && [ -n "$SNMPUSER4ENGINID" ]
then
   echo "createUser -e $SNMPUSER4ENGINID $SNMPUSER4USRNAME $SNMPUSER4AUTHALG $SNMPUSER4AUTHPHR $SNMPUSER4PRIVALG $SNMPUSER4PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER4USRNAME" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER4USRNAME" ]
then
    echo "createUser $SNMPUSER4USRNAME $SNMPUSER4AUTHALG $SNMPUSER4AUTHPHR $SNMPUSER4PRIVALG $SNMPUSER4PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER4USRNAME" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER5
if [ -n "$SNMPUSER5USRNAME" ] && [ -n "$SNMPUSER5ENGINID" ]
then
   echo "createUser -e $SNMPUSER5ENGINID $SNMPUSER5USRNAME $SNMPUSER5AUTHALG $SNMPUSER5AUTHPHR $SNMPUSER5PRIVALG $SNMPUSER5PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER5USRNAME" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER5USRNAME" ]
then
    echo "createUser $SNMPUSER5USRNAME $SNMPUSER5AUTHALG $SNMPUSER5AUTHPHR $SNMPUSER5PRIVALG $SNMPUSER5PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER5USRNAME" >> /etc/snmp/snmptrapd.conf
fi

snmptrapd -ALf /var/log/snmp/snmptrapd.log
frontail -d -p $HTTPPORT /var/log/snmp/snmptrapd.log

# Keep docker running
bash
