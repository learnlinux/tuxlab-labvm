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
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    echo -e 'AuthenticationMethods "password"\n' >> /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && \
    echo "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNrU4Sdm8xGnbYMU93ixRsvTn+CgHttsNHE97EbiwjDsmvYNeYak4aCo0mzQaC3qNEBZsUPhjWJAO3Fck/nm4dk= root@65b5c3d5ba10" > /etc/ssh/ssh_host_ecdsa_key.pub && \
    echo '''-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIAJ0GmUKarlNgyvzmx8+H9LasnunIQQqt4U7S1nELNKyoAoGCCqGSM49
AwEHoUQDQgAE2tThJ2bzEadtgxT3eLFGy9Of4KAe22w0cT3sRuLCMOya9g15hqTh
oKjSbNBoLeo0QFmxQ+GNYkA7cVyT+ebh2Q==
-----END EC PRIVATE KEY-----''' > /etc/ssh/ssh_host_ecdsa_key && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
