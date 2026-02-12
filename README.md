# ssh-vault
A vault system using ssh to remotely lock and unlock a folder (with encryption)

<h1>How to use:</h1>

<p>The vault is seen as a folder on another machine, for example a vps or server.</p>
<code>lock-vault.sh</code> applies encryption to everything in the target folder on the remote machine.<br>
<code>unlock-vault.sh</code> tries to decrypt the target folder's content.

<h3>Steps to set it up</h3>

*  Move script.py, lock-vault.sh and unlock-vault.sh to your client machine.
*  Still on your client machine, generate a key.key file by using the command: python3 script.py genkey. Don't lose this key! Or else your data will be gone forever!
*  Next, try to ssh into your target machine, remember the ssh login, you need to change SSH_IDENTITY in both .sh files.
*  On the target machine, create a folder somewhere and remember the path. Also check if your ssh user has full access over that folder and above-directory. (Creating the folder in ~/ is recommended)
*  Now, go back to your client machine and change both .sh files again, so the vault-folder points to the location of the folder you just created on the target machine. (do not end this path with "/" !)
*  On the client machine, make both .sh files executable. To do this, use "chmod +x lock-vault.sh && chmod +x unlock-vault.sh"
*  Now, ssh into your target machine and try to put a text file or something into your target folder (vault)
*  Go back to your client, and execute "./lock-vault.sh" and check if it works. If things or dependencies are missing, install them.
*  To check if it worked, ssh into your target machine again and check if all folders and files inside the target folder (vault) are gone except "data.txt" try to cat data.txt. If it worked, you will see random chars.
*  Now, go back to your client and try to run "./unlock-vault.sh" and check if the files inside the folder (vault) on the target machine are back to normal.
