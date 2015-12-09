#!/bin/bash -e

REPO=${REPO:-"machinekit/machinekit"}

if [ -z "${TRAVIS_TOKEN}" ]; then
    INTERACTIVE=" -it"
else
    INTERACTIVE=""
fi

# encrypt sftp key
docker run --rm=true ${INTERACTIVE} -v $(pwd):/root \
    -e TRAVIS_TOKEN=${TRAVIS_TOKEN} -e REPO \
    travis-cli sh -c "cmds/encrypt_helper.sh keys/access_key"

mkdir -p www/travis/${REPO//\//.}
mv access_key.enc www/travis/${REPO//\//.}/access_key.enc

