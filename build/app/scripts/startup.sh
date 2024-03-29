#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

# Extract compressed binaries and move binaries to bin
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    # Unzip frontail and tailon
    if [[ $(arch) == "x86_64" ]]; then
        gunzip /usr/local/bin/frontail.gz
    fi
    gunzip /usr/local/bin/tailon.gz

    # Copy python scripts to /usr/local/bin and make executable
    cp /opt/"$APPNAME"/scripts/add_snmp_users.py /usr/local/bin
    cp /opt/"$APPNAME"/scripts/send_test_trap.py /usr/local/bin
    cp /opt/"$APPNAME"/scripts/column.py /usr/local/bin
    cp /opt/"$APPNAME"/scripts/menu /usr/local/bin
    chmod 755 /usr/local/bin/add_snmp_users.py
    chmod 755 /usr/local/bin/send_test_trap.py
    chmod 755 /usr/local/bin/column.py
    chmod 775 /usr/local/bin/menu
fi

# Link scripts to debug folder as needed
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    ln -s /opt/"$APPNAME"/scripts/tail.sh /opt/"$APPNAME"/debug
    ln -s /opt/"$APPNAME"/scripts/tmux.sh /opt/"$APPNAME"/debug
    ln -s /opt/"$APPNAME"/scripts/send_test_trap.py /opt/"$APPNAME"/debug
    ln -s /opt/"$APPNAME"/scripts/menu /opt/"$APPNAME"/debug
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

# Check if `upload` subfolder exists. If non-existing, create it .
# Checking for a file inside the folder because if the folder
#  is mounted as a volume it will already exists when docker starts.
# Also change permissions
if [ ! -e "/opt/$APPNAME/upload/.exists" ]
then
    mkdir -p /opt/"$APPNAME"/upload
    touch /opt/"$APPNAME"/upload/.exists
    echo '`upload` folder created'
    cp /opt/"$APPNAME"/configs/snmp_users.csv /opt/"$APPNAME"/upload
    chown -R "${HUID}":"${HGID}" /opt/"$APPNAME"/upload
fi

# Modify configuration files or customize container
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    # Configure snmp
    cp /opt/"$APPNAME"/configs/snmp.conf /etc/snmp/snmp.conf
    cp /opt/"$APPNAME"/configs/snmpd.conf /etc/snmp/snmpd.conf
    cp /opt/"$APPNAME"/configs/snmptrapd.conf /etc/snmp/snmptrapd.conf

    # Copy templates to configuration locations
    cp /opt/"$APPNAME"/configs/tmux.conf /root/.tmux.conf

    # Create menu.json
    /opt/"$APPNAME"/scripts/make_menujson.py /opt/"$APPNAME"/scripts/menu.json
fi

# Run the python script to add all the snmptrap users
add_snmp_users.py >> /opt/"$APPNAME"/logs/"$APPNAME".log

# Start services
# Start snmp services
service snmpd start
service snmptrapd start

# Start web interface
NLINES=1000 # how many tail lines to follow
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tail.sh
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tmux.sh
sed -Ei 's/\$lines/'"$NLINES"'/' /opt/"$APPNAME"/configs/tailon.toml
sed -Ei '/^listen-addr = /c listen-addr = [":'"$HTTPPORT4"'"]' /opt/"$APPNAME"/configs/tailon.toml

# ttyd1 (tail and read only)
nohup ttyd \
    --port "$HTTPPORT1" \
    --client-option titleFixed="${APPNAME}.log" \
    --client-option fontSize=16 \
    --client-option 'theme={"foreground":"black","background":"white","selectionBackground":"#ff6969"}' \
    --signal 2 \
    /opt/"$APPNAME"/scripts/tail.sh \
    >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &

# ttyd2 (tmux and interactive)
nohup ttyd \
    --writable \
    --port "$HTTPPORT2" \
    --client-option titleFixed="${APPNAME}.log" \
    --client-option fontSize=16 \
    --client-option 'theme={"foreground":"black","background":"white","selectionBackground":"#ff6969"}' \
    --signal 9 \
    /opt/"$APPNAME"/scripts/tmux.sh \
    >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &

# frontail
if [[ $(arch) == "x86_64" ]]; then
    nohup frontail \
        -n "$NLINES" \
        -p "$HTTPPORT3" \
        /opt/"$APPNAME"/logs/"$APPNAME".log \
        >> /opt/"$APPNAME"/logs/frontail.log 2>&1 &
fi

# tailon
nohup tailon \
    -c /opt/"$APPNAME"/configs/tailon.toml \
    /opt/"$APPNAME"/logs/"$APPNAME".log \
    /opt/"$APPNAME"/logs/ttyd1.log \
    /opt/"$APPNAME"/logs/ttyd2.log \
    /opt/"$APPNAME"/logs/frontail.log \
    /opt/"$APPNAME"/logs/tailon.log \
    >> /opt/"$APPNAME"/logs/tailon.log 2>&1 &

# Remove the .firstrun file if this is the first run
if [ -e /opt/"$APPNAME"/scripts/.firstrun ]; then
    rm -f /opt/"$APPNAME"/scripts/.firstrun
fi

# Keep docker running
bash
