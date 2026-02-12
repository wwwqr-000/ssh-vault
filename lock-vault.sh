#!/bin/bash

set -e #Enable exit on negative return value of one of the commands

REMOTE_VAULT_DIR="~/vault" #Change this to your target folder to see as the "vault"
SSH_IDENTITY="root@192.168.0.1" #Change this to your ssh arguments

#Send files "script.py" and "key.key" as datastream across ssh
tar cz script.py key.key | ssh $SSH_IDENTITY "

#Check if data.txt already exists, stop if true
if [ -f $REMOTE_VAULT_DIR/data.txt ]; then
    echo 'data.txt already exists! Already encrypted... Aborted.'
    exit 1
fi
#

cd $REMOTE_VAULT_DIR

tar --exclude=data.txt -cvf data.txt . #Create a tar file including all files in the current directory

find . -mindepth 1 -maxdepth 1 ! -name 'data.txt' -exec rm -rf {} + #Remove all the files from the directory except the tar file

cd .. #Move to the directory above the target folder

tar xz #Extract the given files from the ssh datastream in the current directory

python3 script.py enc $REMOTE_VAULT_DIR #Run encryption script

#Remove used tool and key, leaving only data.txt behind in the target folder
rm key.key
rm script.py
#
"
