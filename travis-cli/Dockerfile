FROM    debian:jessie
MAINTAINER  GP Orcullo <kinsamanka@gmail.com>

RUN apt-get update ; \
    apt-get install -y --no-install-recommends \
        build-essential ruby ruby-dev; \
    gem install --clear-sources --no-document travis && \
    apt-get remove -y build-essential ruby-dev && \
    apt-get autoremove -y

RUN useradd -m -s /bin/bash travis
USER    root
WORKDIR /root

