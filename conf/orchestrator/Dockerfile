FROM debian:stretch

MAINTAINER Nikolaos Vyzas <nick@proxysql.com>

EXPOSE 3000

RUN apt update && apt -y install wget && wget https://github.com/github/orchestrator/releases/download/v3.1.2/orchestrator_3.1.2_amd64.deb && apt -y install ./orchestrator_3.1.2_amd64.deb && mkdir /var/lib/orchestrator && rm -rf /var/lib/apt/lists/*

CMD /usr/local/orchestrator/orchestrator http

