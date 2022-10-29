#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

# Extract compressed binaries and move binaries to bin
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    # Unzip frontail and tailon
    gunzip /usr/local/bin/frontail.gz
    gunzip /usr/local/bin/tailon.gz
fi

# Link scripts to debug folder as needed
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    ln -s /opt/"$APPNAME"/scripts/tail.sh /opt/"$APPNAME"/debug
    ln -s /opt/"$APPNAME"/scripts/tmux.sh /opt/"$APPNAME"/debug
    ln -s /opt/"$APPNAME"/scripts/send_test_trap.sh /opt/"$APPNAME"/debug
fi

# Create the file /var/run/utmp or when using tmux this error will be received
# utempter: pututline: No such file or directory
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    touch /var/run/utmp
else
    truncate -s 0 /var/run/utmp
fi

# Link the log to the app log. Create/clear other log files.
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    mkdir -p /opt/"$APPNAME"/logs
    ln -s /var/log/snmp/snmptrapd.log /opt/"$APPNAME"/logs/"$APPNAME".log
else
    truncate -s 0 /opt/"$APPNAME"/logs/"$APPNAME".log
fi

# Print first message to either the app log file or syslog
echo "$(date -Is) [Start of $APPNAME log file]" >> /opt/"$APPNAME"/logs/"$APPNAME".log

# Modify configuration files or customize container
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    # Configure snmp
    cp /opt/"$APPNAME"/configs/snmp.conf /etc/snmp/snmp.conf
    cp /opt/"$APPNAME"/configs/snmpd.conf /etc/snmp/snmpd.conf
    cp /opt/"$APPNAME"/configs/snmptrapd.conf /etc/snmp/snmptrapd.conf

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
fi

# Start services
# Start snmp services
service snmpd start
service snmptrapd start

# Start web interface
NLINES=1000 # how many tail lines to follow

# ttyd1 (tail and read only)
# to remove color add the option `-T xterm-mono`
# selection changed to selectionBackground in 1.7.2 - bug reported
# `-t 'theme={"foreground":"black","background":"white", "selection":"#ff6969"}'` # 69, nice!
# `-t 'theme={"foreground":"black","background":"white", "selectionBackground":"#ff6969"}'`
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tail.sh
nohup ttyd -p "$HTTPPORT1" -R -t titleFixed="${APPNAME}.log" -t fontSize=16 -t 'theme={"foreground":"black","background":"white", "selectionBackground":"#ff6969"}' -s 2 /opt/"$APPNAME"/scripts/tail.sh >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &

# ttyd2 (tmux with color)
# to remove color add the option `-T xterm-mono`
# selection changed to selectionBackground in 1.7.2 - bug reported
# `-t 'theme={"foreground":"black","background":"white", "selection":"#ff6969"}'` # 69, nice!
# `-t 'theme={"foreground":"black","background":"white", "selectionBackground":"#ff6969"}'`
cp /opt/"$APPNAME"/configs/tmux.conf /root/.tmux.conf
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tmux.sh
nohup ttyd -p "$HTTPPORT2" -t titleFixed="${APPNAME}.log" -t fontSize=16 -t 'theme={"foreground":"black","background":"white", "selectionBackground":"#ff6969"}' -s 9 /opt/"$APPNAME"/scripts/tmux.sh >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &

# frontail
nohup frontail -n "$NLINES" -p "$HTTPPORT3" /opt/"$APPNAME"/logs/"$APPNAME".log >> /opt/"$APPNAME"/logs/frontail.log 2>&1 &

# tailon
sed -Ei 's/\$lines/'"$NLINES"'/' /opt/"$APPNAME"/configs/tailon.toml
sed -Ei '/^listen-addr = /c listen-addr = [":'"$HTTPPORT4"'"]' /opt/"$APPNAME"/configs/tailon.toml
nohup tailon -c /opt/"$APPNAME"/configs/tailon.toml /opt/"$APPNAME"/logs/"$APPNAME".log /opt/"$APPNAME"/logs/ttyd1.log /opt/"$APPNAME"/logs/ttyd2.log /opt/"$APPNAME"/logs/frontail.log /opt/"$APPNAME"/logs/tailon.log >> /opt/"$APPNAME"/logs/tailon.log 2>&1 &

# Remove the .firstrun file if this is the first run
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    rm -f /opt/"$APPNAME"/scripts/.firstrun
fi

# Keep docker running
bash
