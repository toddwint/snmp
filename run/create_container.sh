#!/usr/bin/env bash
REPO=toddwint
APPNAME=snmp
source "$(dirname "$(realpath $0)")"/config.txt

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

# Create the webadmin html file from template
htmltemplate="$(dirname "$(realpath $0)")"/webadmin.html.template
htmlfile="$(dirname "$(realpath $0)")"/webadmin.html
cp "$htmltemplate" "$htmlfile"
sed -Ei 's/(Launch page for webadmin)/\1 - '"$HOSTNAME"'/g' "$htmlfile"
sed -Ei 's/\bIPADDR:HTTPPORT1\b/'"$IPADDR"':'"$HTTPPORT1"'/g' "$htmlfile"
sed -Ei 's/\bIPADDR:HTTPPORT2\b/'"$IPADDR"':'"$HTTPPORT2"'/g' "$htmlfile"
sed -Ei 's/\bIPADDR:HTTPPORT3\b/'"$IPADDR"':'"$HTTPPORT3"'/g' "$htmlfile"
sed -Ei 's/\bIPADDR:HTTPPORT4\b/'"$IPADDR"':'"$HTTPPORT4"'/g' "$htmlfile"

# Give the user instructions and offer to launch webadmin page
echo 'Open webadmin.html to use this application (`firefox webadmin.html &`)'
read -rp 'Would you like me to open that now? [Y/n]: ' answer
if [ -z ${answer} ]; then answer='y'; fi
if [[ ${answer,,} =~ ^y ]] 
then
    firefox "$htmlfile" &
fi
