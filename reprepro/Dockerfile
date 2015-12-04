FROM    debian:jessie
MAINTAINER  GP Orcullo <kinsamanka@gmail.com>

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        dpkg-sig \
        gnupg \
        inoticoming \
        reprepro

ADD process.sh /
ADD run.sh /
ADD clean_stale_files /etc/cron.d/

ENV CONF_DIR    /conf
ENV INFO_DIR    /data/sftp/shared/info
ENV INCOMING_DIR    /incoming
ENV FAIL_DIR    /data/failed
ENV KEYS_DIR	/keys
ENV GPG_KEY	no_passwd_reprepro.key
ENV PASS_DIR    /data/passed
ENV QUEUE_DIR   /data/queue
ENV TEMP_DIR    /data/tmp
ENV GNUPGHOME	/data/.gpg

VOLUME  /data /conf /archive

CMD /run.sh

