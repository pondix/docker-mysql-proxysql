FROM debian:stretch

MAINTAINER Nikolaos Vyzas <nvyzas@gmail.com>

EXPOSE 3000

RUN apt update && apt -y install wget curl mysql-client && wget https://github.com/openark/orchestrator/releases/download/v3.2.6/orchestrator_3.2.6_amd64.deb && apt -y install ./orchestrator_3.2.6_amd64.deb && wget https://github.com/openark/orchestrator/releases/download/v3.2.6/orchestrator-client_3.2.6_amd64.deb && apt -y install ./orchestrator-client_3.2.6_amd64.deb && mkdir /var/lib/orchestrator && rm -rf /var/lib/apt/lists/*

CMD /usr/local/orchestrator/orchestrator http

