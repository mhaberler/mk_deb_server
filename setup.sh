#!/bin/bash -e

# build tools
docker build -t travis-cli travis-cli

# generate ssh key
if [ ! -f keys/access_key ]; then
     docker run --rm=true -v $(pwd):/home/travis travis-cli sh -ec \
        'ssh-keygen -t rsa -N "" -f keys/access_key'
fi

docker-compose build

