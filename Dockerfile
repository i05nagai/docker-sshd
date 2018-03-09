FROM ubuntu:16.04

RUN \
    apt-get update \
    && apt-get install -y \
        openssh-server \
        supervisor \
        netcat \
        bash-completion \
    && mkdir /var/run/sshd

EXPOSE 22
COPY ./templates /

ENTRYPOINT ["/opt/sshd/entrypoint.sh", "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
