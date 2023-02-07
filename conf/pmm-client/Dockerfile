FROM debian:bullseye

MAINTAINER Nikolaos Vyzas <nvyzas@gmail.com>

RUN apt update && apt -y install lsb-release wget curl && wget https://downloads.percona.com/downloads/pmm2/2.34.0/binary/debian/bullseye/x86_64/pmm2-client_2.34.0-6.bullseye_amd64.deb && dpkg -i pmm2-client_2.34.0-6.bullseye_amd64.deb && rm -rf /var/lib/apt/lists/*

CMD ["/entrypoint.bash"]

