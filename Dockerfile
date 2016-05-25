FROM alpine:latest

MAINTAINER Andrew Cutler <andrew@panubo.com>

RUN apk update && \
    apk add bash git openssh rsync && \
    mkdir -p ~root/.ssh && chmod 700 ~root/.ssh/ && \
    sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config && \
    sed -i 's/#RSAAuthentication yes/RSAAuthentication no/g' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication no/g' /etc/ssh/sshd_config && \
    sed -i 's/#HostbasedAuthentication no/HostbasedAuthentication yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#IgnoreUserKnownHosts no/IgnoreUserKnownHosts yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    echo -e 'AuthenticationMethods "password"\n' >> /etc/ssh/sshd_config && \
    pwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1) && \
    echo $pwd >> /passwd && \
    echo "root:"$pwd | chpasswd && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
