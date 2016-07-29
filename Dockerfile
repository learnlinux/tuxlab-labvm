FROM alpine:latest

MAINTAINER Andrew Cutler <andrew@panubo.com>

COPY files/entry.sh entry.sh
COPY files/sshd_banner /etc/ssh/sshd_banner
COPY files/motd /etc/motd
COPY files/install.sh /root/install.sh

RUN ./install.sh && \
    rm install.sh

EXPOSE 22

ENTRYPOINT ["/entry.sh"]
