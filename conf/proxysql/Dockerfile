FROM debian:stretch

MAINTAINER Nikolaos Vyzas <pondix@gmail.com>

COPY ./patches/main.cpp.patch.txt /tmp/main.cpp.patch.txt
COPY ./patches/mysql_data_stream.cpp.patch.txt /tmp/mysql_data_stream.cpp.patch.txt
RUN apt-get update && apt-get install -y automake \
       cmake \
       equivs \
       make \
       g++ \
       gcc \
       gdb \
       gdbserver \
       git \
       python \
       libmariadbclient-dev \
       libssl-dev \
       libtool \
       vim \
    && rm -rf /var/lib/apt/lists/* \
    && cd /opt \
    && git clone -b v2.0-lab https://github.com/sysown/proxysql.git proxysql \
    && cd proxysql \
    && patch /opt/proxysql/lib/mysql_data_stream.cpp < /tmp/mysql_data_stream.cpp.patch.txt \
    && patch /opt/proxysql/src/main.cpp < /tmp/main.cpp.patch.txt \
    && make \
    && make install 
ENTRYPOINT ["proxysql", "-f", "-D", "/var/lib/proxysql"]
