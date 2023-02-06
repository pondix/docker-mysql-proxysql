FROM debian:stretch

MAINTAINER Nikolaos Vyzas <nick@proxysql.com>

EXPOSE 3000

RUN apt update && apt -y install wget curl && wget https://github.com/github/orchestrator/releases/download/v3.1.2/orchestrator_3.1.2_amd64.deb && apt -y install ./orchestrator_3.1.2_amd64.deb && wget https://github.com/openark/orchestrator/releases/download/v3.2.6/orchestrator-client_3.2.6_amd64.deb && apt -y install ./orchestrator-client_3.2.6_amd64.deb && mkdir /var/lib/orchestrator && rm -rf /var/lib/apt/lists/*

CMD /usr/local/orchestrator/orchestrator http

