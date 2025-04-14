FROM debian:bullseye

MAINTAINER Nikolaos Vyzas <nvyzas@gmail.com>

RUN apt update && apt -y install lsb-release wget curl gnupg2 && wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb && dpkg -i percona-release_latest.generic_all.deb && percona-release enable pmm3-client release && apt update && apt -y install pmm-client && rm -rf /var/lib/apt/lists/*

CMD ["/entrypoint.bash"]

