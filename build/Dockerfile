FROM ubuntu:focal
COPY scripts /opt/snmp/scripts
EXPOSE 162/udp 162/tcp 161/udp 161/tcp 9001
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HTTPPORT=9001 \
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
    SNMPUSER5PRIVPHR=privacyphrase5 
RUN apt-get update \
    && \
    apt-get install -y \
    tzdata \
    iproute2 \
    wget \
    snmp \
    snmptrapd \
    libsnmp-dev \
    snmp-mibs-downloader \
    && \
    mkdir -p /opt/snmp/data \
    && \
    wget -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux -O /usr/local/bin/frontail \
    && \
    chmod 755 /usr/local/bin/frontail \
    && \
    download-mibs \
    && \
    download-mibs \
    && \
    sed -i "s/^\(mibs *:\).*/#\1/" /etc/snmp/snmp.conf \
    && \
    sed -i "s/#\(authCommunity.*public.*\)/\1/" /etc/snmp/snmptrapd.conf \
    && \
    sed -i "s/^\(agentaddress\).*/\1  0.0.0.0,[::]/" /etc/snmp/snmpd.conf \
    && \
    mkdir /var/log/snmp \
#    && \
#    apt-get remove -y \
#    wget \
#    && \
#    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/snmp/
CMD ["/opt/snmp/scripts/startup.sh"]
