FROM    debian:jessie
MAINTAINER  GP Orcullo <kinsamanka@gmail.com>

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        openssh-server && \
    mkdir -p /var/run/sshd

# sshd needs this directory to run
RUN mkdir -p /var/run/sshd

ADD sshd_config /etc/ssh/sshd_config
ADD run.sh /

VOLUME  /keys

CMD /run.sh travis

