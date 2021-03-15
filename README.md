# LFS
Based on:<br>
* [Linux From Scratch][1]<br>
* [Beyond Linux® From Scratch (System V Edition)][2]<br><br>
Translated from Russian using google translate.

[1]: http://www.linuxfromscratch.org/lfs/view/stable/index.html
[2]: http://www.linuxfromscratch.org/blfs/view/stable/index.html


General guide to using these build scripts.

Stage 1: *use* 

check-host-system-requirements.sh

create-lfs-user.sh

download-src.sh

**Do not use**:partitions-init.sh we will set up partitions using gparted.

   
The conditions are a host machine running ubuntu 18 on oracle virtualbox and building LFS on a second drive (/dev/sdb) partitioned as GPT with a 1mb partition for bios boot at /dev/sdb1 and your main drive for the LFS build at /dev/sdb2 I setup this partition using an ubuntu 18 live cd via virtualbox and used gparted to set this up, then booted back into the ubuntu 18 machine.

In your settings -> storage of the host machine it gives you the option to create extra hard drives, use that. Then create the LFS drive. Then create a new virtual machine. Attach that second drive as its primary drive, load up the ubuntu 18 desktop live iso, boot from that and use gparted to set up the disk. Remember to set the bios flag on the 1mb partition, and that partition should be **unformatted** theres a specific option to leave it unformatted there. The rest of the drive partition as EXT4 and set the bootable flag.

Prep: Mount your LFS drive as per the book. Then as the root user change directory to the sources folder and git clone this repository into it.

`chown lfs:lfs -R $LFS/sources/LFS/lfs/stage-2/stage-2.1`

Stage 2.1: Run queue.sh as the **lfs** user. This portion of the toolchain building has been fully automated. Enjoy.

Stage 2.2: Run queue.sh as the *root* user. This portion of the toolchain building has been fully automated. Enjoy.

Stage 3: **Stage 3 automation is not complete do not run queue.sh it will leave out packages**

From the stage 3 folder as the root user run 
```
cp -v removepkg /mnt/lfs/sbin/
chown root:root /mnt/lfs/sbin/removepkg
chmod 744       /mnt/lfs/sbin/removepkg

cp *.sh $LFS

./mount-virtual-kernel-file-systems.sh --mount

./entering-chroot-env.sh

chmod 744 *.sh
```

Then change directory back to /sources/LFS/lfs/stage-3

Run each build script in the order they are listed in queue.sh 

It will be helpful if you have this open in a text editor somewhere so you have that list.

Once stage 3 is complete exit out of the chroot and run rm *.sh $LFS

Stage 4: Run queue.sh as the *root* user. This portion of the build has been fully automated. Enjoy.

Stage 5: Run queue.sh as the *root* user. This portion of the build has been fully automated. Enjoy.

Finally. reenter the chroot.


Install DHCP from the blfs. http://www.linuxfromscratch.org/blfs/view/svn/basicnet/dhcp.html

Follow only the client instructions.

Now we setup grub.

Instead of following the LFS book on how to setup grub im going to tell you how to do it specifically how i did it.

Here is the grub config i used based on the one from chapter 10 here http://www.linuxfromscratch.org/lfs/view/stable/chapter10/grub.html

Do not copy and paste chapter 10. You will break your host system. They seem to be aware you will do this and instruct you to make a grub disc. Instead of just telling you how to do it right in the first place.

When you install grub itself as shown in the LFS book via grub-install it tells you to point it at /dev/sda

This is wrong and will break your grub for the host machine. Point it to /dev/sdb *while you are chrooted into the LFS system*

You do not need to specify sdb1 or 2 and it will break things if you try to specify it. Dont do that. Just use /dev/sdb 
```
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,gpt2)

menuentry "GNU/Linux, vmlinuz-lfs-5.10.17" {
        linux   vmlinuz-lfs-5.10.17 root=/dev/sda2 init=/sbin/init ro
}
EOF
```

We change it here to /dev/sda2 because thats what it will be when we boot up that drive in its own virtual machine.


the insmod part_gpt is absolutely needed as grub needs this to see a gpt partition, this is not noted in the book.

Included in my version of the LFS build scripts is a kernel configuration that installs the network drivers that virtualbox uses and the options needed to make DHCP work. 

After this exit the chroot unmount any drives and shut down the host system then boot into the second virtual machine using the LFS hard drive.

The BLFS scripts *are not ready yet* so please do not use them yet.
