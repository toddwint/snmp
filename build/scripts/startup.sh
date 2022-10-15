#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

# Unzip frontail and tailon
gunzip /usr/local/bin/frontail.gz
gunzip /usr/local/bin/tailon.gz

# Configure snmp
sed -Ei "s/^(mibs *:).*/#\1/" /etc/snmp/snmp.conf 
sed -Ei "s/^(agentaddress).*/\1  0.0.0.0,[::]/" /etc/snmp/snmpd.conf 
sed -Ei "s/^#(authCommunity.*public.*)/\1/" /etc/snmp/snmptrapd.conf 
sed -Ei '$a[snmp] logOption f /var/log/snmp/snmptrapd.log' /etc/snmp/snmptrapd.conf

# SNMPUSER1
if [ -n "$SNMPUSER1USRNAME" ] && [ -n "$SNMPUSER1ENGINID" ]
then
   echo "createUser -e $SNMPUSER1ENGINID $SNMPUSER1USRNAME $SNMPUSER1AUTHALG $SNMPUSER1AUTHPHR $SNMPUSER1PRIVALG $SNMPUSER1PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER1USRNAME noauth" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER1USRNAME" ]
then
    echo "createUser $SNMPUSER1USRNAME $SNMPUSER1AUTHALG $SNMPUSER1AUTHPHR $SNMPUSER1PRIVALG $SNMPUSER1PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER1USRNAME noauth" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER2
if [ -n "$SNMPUSER2USRNAME" ] && [ -n "$SNMPUSER2ENGINID" ]
then
   echo "createUser -e $SNMPUSER2ENGINID $SNMPUSER2USRNAME $SNMPUSER2AUTHALG $SNMPUSER2AUTHPHR $SNMPUSER2PRIVALG $SNMPUSER2PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER2USRNAME noauth" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER2USRNAME" ]
then
    echo "createUser $SNMPUSER2USRNAME $SNMPUSER2AUTHALG $SNMPUSER2AUTHPHR $SNMPUSER2PRIVALG $SNMPUSER2PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER2USRNAME noauth" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER3
if [ -n "$SNMPUSER3USRNAME" ] && [ -n "$SNMPUSER3ENGINID" ]
then
   echo "createUser -e $SNMPUSER3ENGINID $SNMPUSER3USRNAME $SNMPUSER3AUTHALG $SNMPUSER3AUTHPHR $SNMPUSER3PRIVALG $SNMPUSER3PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER3USRNAME noauth" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER3USRNAME" ]
then
    echo "createUser $SNMPUSER3USRNAME $SNMPUSER3AUTHALG $SNMPUSER3AUTHPHR $SNMPUSER3PRIVALG $SNMPUSER3PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER3USRNAME noauth" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER4
if [ -n "$SNMPUSER4USRNAME" ] && [ -n "$SNMPUSER4ENGINID" ]
then
   echo "createUser -e $SNMPUSER4ENGINID $SNMPUSER4USRNAME $SNMPUSER4AUTHALG $SNMPUSER4AUTHPHR $SNMPUSER4PRIVALG $SNMPUSER4PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER4USRNAME noauth" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER4USRNAME" ]
then
    echo "createUser $SNMPUSER4USRNAME $SNMPUSER4AUTHALG $SNMPUSER4AUTHPHR $SNMPUSER4PRIVALG $SNMPUSER4PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER4USRNAME noauth" >> /etc/snmp/snmptrapd.conf
fi

# SNMPUSER5
if [ -n "$SNMPUSER5USRNAME" ] && [ -n "$SNMPUSER5ENGINID" ]
then
   echo "createUser -e $SNMPUSER5ENGINID $SNMPUSER5USRNAME $SNMPUSER5AUTHALG $SNMPUSER5AUTHPHR $SNMPUSER5PRIVALG $SNMPUSER5PRIVPHR" >> /etc/snmp/snmptrapd.conf
   echo "authUser log,execute,net $SNMPUSER5USRNAME noauth" >> /etc/snmp/snmptrapd.conf
elif [ -n "$SNMPUSER5USRNAME" ]
then
    echo "createUser $SNMPUSER5USRNAME $SNMPUSER5AUTHALG $SNMPUSER5AUTHPHR $SNMPUSER5PRIVALG $SNMPUSER5PRIVPHR" >> /etc/snmp/snmptrapd.conf
    echo "authUser log,execute,net $SNMPUSER5USRNAME noauth" >> /etc/snmp/snmptrapd.conf
fi

# Start snmp services
service snmpd stop
service snmptrapd stop
service snmpd start
service snmptrapd start
service snmpd status
service snmptrapd status

# Create logs folder and init files
mkdir -p /opt/"$APPNAME"/logs
touch /opt/"$APPNAME"/logs/"$APPNAME".log
truncate -s 0 /opt/"$APPNAME"/logs/"$APPNAME".log
echo "$(date -Is) [Start of $APPNAME log file]" >> /opt/"$APPNAME"/logs/"$APPNAME".log

# Start web interface
NLINES=1000
cp /opt/"$APPNAME"/scripts/tmux.conf /root/.tmux.conf
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tail.sh
# ttyd tail with color and read only
nohup ttyd -p "$HTTPPORT1" -R -t titleFixed="${APPNAME}|${APPNAME}.log" -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tail.sh >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &
# ttyd tail without color and read only
#nohup ttyd -p "$HTTPPORT1" -R -t titleFixed="${APPNAME}|${APPNAME}.log" -T xterm-mono -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tail.sh >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tmux.sh
# ttyd tmux with color
nohup ttyd -p "$HTTPPORT2" -t titleFixed="${APPNAME}|${APPNAME}.log" -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux.sh >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &
# ttyd tmux without color
#nohup ttyd -p "$HTTPPORT2" -t titleFixed="${APPNAME}|${APPNAME}.log" -T xterm-mono -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux.sh >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &
nohup frontail -n "$NLINES" -p "$HTTPPORT3" /var/log/snmp/snmptrapd.log >> /opt/"$APPNAME"/logs/frontail.log 2>&1 &
sed -Ei 's/\$lines/'"$NLINES"'/' /opt/"$APPNAME"/scripts/tailon.toml
sed -Ei '/^listen-addr = /c listen-addr = [":'"$HTTPPORT4"'"]' /opt/"$APPNAME"/scripts/tailon.toml
nohup tailon -c /opt/"$APPNAME"/scripts/tailon.toml /var/log/snmp/snmptrapd.log /opt/"$APPNAME"/logs/ttyd1.log /opt/"$APPNAME"/logs/ttyd2.log /opt/"$APPNAME"/logs/frontail.log /opt/"$APPNAME"/logs/tailon.log >> /opt/"$APPNAME"/logs/tailon.log 2>&1 &

# Keep docker running
bash
