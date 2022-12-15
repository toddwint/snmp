FROM toddwint/mybaseimage
COPY app /opt/snmp
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
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
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/snmp/debug
CMD ["/opt/snmp/scripts/startup.sh"]
