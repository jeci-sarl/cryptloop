cryptloop
=========

Bash script helping create loop file white ext4 an encryption.


Example
=======

$ ./clsetup.sh fileEncrypt.ext4

The programme query the size of disk file need. Type a number in MB without G, M, k 

# Size off disk ? (in MB)
512

Then th program query sudo password. It is need to mount anything on the system.

[sudo] password for jlesage: 


Then the secret passphrase. Don't ever forget it !

Enter passphrase: 
Verify passphrase: 

Finaly a 'empty' file was created :

du -sh fileEncrypt.ext4
513M	fileEncrypt.ext4

Usualy I create this file directly on usb key.


$ ./clmount.sh fileEncrypt.ext4 /mnt
