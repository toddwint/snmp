FROM toddwint/mybaseimage
COPY scripts /opt/snmp/scripts
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    SNMPUSER1ENGINID=0x0102030405 \
    SNMPUSER1USRNAME=user1 \
    SNMPUSER1AUTHALG=SHA \
    SNMPUSER1AUTHPHR=authphrase1 \
    SNMPUSER1PRIVALG=AES \
    SNMPUSER1PRIVPHR=privacyphrase1 \
    SNMPUSER2ENGINID=0x0102030405 \
    SNMPUSER2USRNAME=user2 \
    SNMPUSER2AUTHALG=SHA \
    SNMPUSER2AUTHPHR=authphrase2 \
    SNMPUSER2PRIVALG=AES \
    SNMPUSER2PRIVPHR=privacyphrase2 \
    SNMPUSER3ENGINID=0x0102030405 \
    SNMPUSER3USRNAME=user3 \
    SNMPUSER3AUTHALG=SHA \
    SNMPUSER3AUTHPHR=authphrase3 \
    SNMPUSER3PRIVALG=AES \
    SNMPUSER3PRIVPHR=privacyphrase3 \
    SNMPUSER4ENGINID=0x0102030405 \
    SNMPUSER4USRNAME=user4 \
    SNMPUSER4AUTHALG=SHA \
    SNMPUSER4AUTHPHR=authphrase4 \
    SNMPUSER4PRIVALG=AES \
    SNMPUSER4PRIVPHR=privacyphrase4 \
    SNMPUSER5ENGINID=0x0102030405 \
    SNMPUSER5USRNAME=user5 \
    SNMPUSER5AUTHALG=SHA \
    SNMPUSER5AUTHPHR=authphrase5 \
    SNMPUSER5PRIVALG=AES \
    SNMPUSER5PRIVPHR=privacyphrase5 \
    HTTPPORT1=8080 \
    HTTPPORT2=8081 \
    HTTPPORT3=8082 \
    HTTPPORT4=8083 \
    HOSTNAME=snmpsrvr \
    APPNAME=snmp
RUN apt-get update \
    && \
    apt-get install -y \
    snmp-mibs-downloader \
    snmptrapd \
    snmp \
    libsnmp-dev \
    && \
    download-mibs \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    mkdir /var/log/snmp \
    && \
    cd /opt \
    && \
    rm -rf /opt/mybaseimage \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/snmp/scripts
CMD ["/opt/snmp/scripts/startup.sh"]
