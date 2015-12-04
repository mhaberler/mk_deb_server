#!/bin/bash -e

# create shared directories
mkdir -p /data/sftp/shared/{info,incoming}
chmod 0777 /data/sftp/shared/{info,incoming}

user=${1:-sftp}

# get owner of shared directory
set -- $(ls -ldn /data/sftp/shared/incoming)
uid="${3}"
gid="${4}"

# create a user that shares the same uid/gid as the owner of
# the incoming directory to solve issues with file ownership.
# this is needed when using this container with boot2docker

useradd_ops="--create-home --no-user-group --non-unique"
# make sure uid is not root
if [ ${uid} -ne 0 ]; then
    useradd_ops+=" --uid ${uid}"
fi
# make sure gid is not root
if [ ${gid} -ne 0 ]; then
    if ! getent group ${gid} >/dev/null; then
        groupadd --non-unique --gid ${gid} ${gid} 2>/dev/null
    fi
    useradd_ops+=" --gid ${gid}"
fi

if ! getent passwd ${user} >/dev/null; then
    useradd ${useradd_ops} ${user} 2>/dev/null
fi

# create unique password
echo "${user}:$(date -u|sha1sum)" | chpasswd

mkdir -p /home/${user}/.ssh

# check for ssh public keys, create if none is found
if [ "$(ls /keys/*.pub 2>/dev/null )" ]; then
    cat /keys/*.pub >> /home/${user}/.ssh/authorized_keys
else
    ssh-keygen -t rsa -N "" -f /keys/access_key
    cp /keys/access_key.pub /home/${user}/.ssh/authorized_keys
    chown ${user} /keys/access_key
    chmod 0600 /keys/access_key
fi

chown -R ${user} /home/${user}/.ssh
chmod 600 /home/${user}/.ssh/authorized_keys

exec /usr/sbin/sshd -D
