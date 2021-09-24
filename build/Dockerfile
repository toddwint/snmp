FROM ubuntu:focal
COPY scripts /opt/snmp/scripts
EXPOSE 162/udp 161/udp 9001
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV HTTPPORT=9001
RUN apt-get update \
    && \
    apt-get install -y \
    tzdata \
    iproute2 \
    wget \
    snmp \
    snmptrapd \
    libsnmp-dev \
    && \
    mkdir -p /opt/snmp/data \
    && \
    wget -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux -O /usr/local/bin/frontail \
    && \
    chmod 755 /usr/local/bin/frontail \
    && \
    sed -i "s/#\(authCommunity.*public.*\)/\1/" /etc/snmp/snmptrapd.conf \
    && \
    sed -i "s/^\(agentaddress\).*/\1  0.0.0.0,[::]/" /etc/snmp/snmpd.conf \
    && \
    mkdir /var/log/snmp \
    && \
    apt-get remove -y \
    wget \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/snmp/
CMD ["/opt/snmp/scripts/startup.sh"]
