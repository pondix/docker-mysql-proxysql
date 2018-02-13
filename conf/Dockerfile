FROM debian:stretch

MAINTAINER Nikolaos Vyzas <pondix@gmail.com>

RUN apt-get update && apt-get install -y wget lsb-release gnupg && wget -O - 'http://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - && echo deb http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list && apt-get update && apt-get install proxysql && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["proxysql", "-f", "-D", "/var/lib/proxysql"]
