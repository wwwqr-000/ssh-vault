#!/bin/bash

set -e #Enable exit on negative return value of one of the commands

REMOTE_VAULT_DIR="~/vault" #Change this to your target folder to see as the "vault"
SSH_IDENTITY="root@192.168.0.1" #Change this to your ssh arguments

#Send files "script.py" and "key.key" as datastream across ssh
tar cz script.py key.key | ssh $SSH_IDENTITY "

if [ ! -f $REMOTE_VAULT_DIR/data.txt ]; then
        echo 'Can not unlock vault, it was already open/ decrypted... Aborted.'
        exit 1
fi

tar xz #Extract the given files from the ssh datastream in the current directory

python3 script.py dec $REMOTE_VAULT_DIR #Run decryption script

#Remove used tool and key
rm key.key
rm script.py
#

cd $REMOTE_VAULT_DIR #Enter the target folder

tar -xvf data.txt #Extract the tar file (Decrypted here now)

rm data.txt #Remove tar file, not needed anymore
"
