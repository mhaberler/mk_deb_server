#!/bin/bash -e

# create directories
mkdir -p ${FAIL_DIR}
mkdir -p ${PASS_DIR}
mkdir -p ${QUEUE_DIR}
mkdir -p ${TEMP_DIR}
mkdir -p ${GNUPGHOME}
chmod 0700 ${GNUPGHOME}

# cleanup
rm -f ${TEMP_DIR}/*

# import gpg key
if [ -f ${KEYS_DIR}/${GPG_KEY} ]; then
    gpg --import ${KEYS_DIR}/${GPG_KEY} || true
    # extract public key
    tmp=$(gpg --fingerprint | grep ^pub)
    tmp=${tmp##*/}
    tmp=${tmp% *}

    echo "Using GPG key id: "${tmp}

    export GPG_SIG=${tmp}
    sed -e "s/GPG_SIG/${GPG_SIG}/g" ${CONF_DIR}/distributions.in > ${CONF_DIR}/distributions
else
    sed -e '/GPG_SIG/d' ${CONF_DIR}/distributions.in > ${CONF_DIR}/distributions
fi

# start cronjob that deletes stale files that are older than 24 hrs
service cron start

exec inoticoming --initialsearch --foreground ${INFO_DIR} \
    --regexp "(passed|failed)" /bin/bash  /process.sh {} \;

