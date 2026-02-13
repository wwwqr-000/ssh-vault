#!/bin/bash

set -e #Enable exit on negative return value of one of the commands

REMOTE_VAULT_DIR="~/vault" #Change this to your target folder to see as the "vault"
SSH_IDENTITY="small-existor" #Change this to your ssh arguments

KEY_DEVICE_LETTER="D" #The disk label of the usb-stick holding the key file
KEY_FILE="key.key" #The path to the keyfile from the perspective of the usb-stick.

#Mount the usb-stick
sudo mkdir -p /mnt/$KEY_DEVICE_LETTER
sudo mount -t drvfs $KEY_DEVICE_LETTER: /mnt/$KEY_DEVICE_LETTER
#

#Check if keyfile is found or not
if [ ! -f /mnt/$KEY_DEVICE_LETTER/$KEY_FILE ]; then
    echo "key file not found. Aborted."
    exit 1
fi
#

#Send files "script.py" and "key.key" as datastream across ssh
tar cz script.py -C /mnt/$KEY_DEVICE_LETTER $KEY_FILE | ssh $SSH_IDENTITY "

if [ ! -f $REMOTE_VAULT_DIR/data.txt ]; then
        echo 'Can not unlock vault, it was already open/ decrypted... Aborted.'
        exit 1
fi

tar xz #Extract the given files from the ssh datastream in the current directory

python3 script.py dec $REMOTE_VAULT_DIR #Run decryption script

#Remove used tool and key
rm $KEY_FILE
rm script.py
#

cd $REMOTE_VAULT_DIR #Enter the target folder

tar -xvf data.txt #Extract the tar file (Decrypted here now)

rm data.txt #Remove tar file, not needed anymore
"
