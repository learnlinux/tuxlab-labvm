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
    echo -e '-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIDR5HVOyMpzyRTmN0B8fv5HdVS9OUuBXZTf0PCSjKKRDoAoGCCqGSM49\nAwEHoUQDQgAElYtpISmPCgRtCN129dAAo31hbtHpf+1CxT4+2WIGHFVDLLXrqv67\ntHW9+wFskJxR6VEUh7R0e/Ln2ewu6/8sww==\n-----END EC PRIVATE KEY-----' > /etc/ssh/ssh_host_ecdsa_key && \
    echo -e 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJWLaSEpjwoEbQjddvXQAKN9YW7R6X/tQsU+PtliBhxVQyy166r+u7R1vfsBbJCcUelRFIe0dHvy59nsLuv/LMM= root@1a1602f1f244' > /etc/ssh/ssh_host_ecdsa_key.pub && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD date | sha256sum | base64 | head -c 12 > /pass ; pass=$(cat /pass) ; echo "root:"$pass | chpasswd ; /usr/sbin/sshd -D -f /etc/ssh/sshd_config
