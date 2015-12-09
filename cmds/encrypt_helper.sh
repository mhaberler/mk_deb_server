#!/bin/bash -e

die () {
    echo $1
    exit 1
}

# remove old files
rm -rf .travis

if [ -z "${TRAVIS_TOKEN}" ]; then
    travis login --org || die "Cannot login to travis-ci!"
else
    travis login --org --git-token ${TRAVIS_TOKEN} >/dev/null 2>&1 || \
        die "Cannot login to travis-ci!"
fi

ACCESS_TOKEN=`cat ~/.travis/config.yml | grep access_token | sed 's/ *access_token: *//'`;

# encrypt ssh access key
RES=$(travis encrypt-file --org -t ${ACCESS_TOKEN} -f ${1} -r ${REPO} -p 2>/dev/null) || \
    die "No admin access to ${REPO} repository!"

# change file ownership
chown --reference=${1} `basename ${1}`.enc

find_val () {
    echo ${RES} | awk -v ab="$1" '{for(i=1; i< NF;i++) if ($i == ab) print $(i+1)}'
}

key1=$(find_val "-K")
key2=$(find_val "-iv")

# rename encryption key labels to sane values
travis env --org -t ${ACCESS_TOKEN} -r ${REPO} \
        unset ${key1:1} ${key2:1} encrypted_sftp_key encrypted_sftp_iv || \
    die "Cannot delete encryption keys!"

travis env --org -t ${ACCESS_TOKEN} -r ${REPO} \
        set encrypted_sftp_key $(find_val "key:") -p || \
    die "Cannot set encrypted_sftp_key!"
    
travis env --org -t ${ACCESS_TOKEN} -r ${REPO} \
        set encrypted_sftp_iv $(find_val "iv:") -p || \
    die "Cannot set encrypted_sftp_iv!"

rm -rf .travis

