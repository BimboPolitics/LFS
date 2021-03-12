#!/bin/bash

###
# Run as user root
###

cp *.sh $LFS



./changing-ownership.sh
# before running the next script, check the PART variable in it, which
# should point to the partition of the hard drive mounted in/mnt/lfs
./mount-virtual-kernel-file-systems.sh --mount

###
# Go to the chroot environment
./entering-chroot-env.sh <<"EOT"
###
chmod 744 *.sh
./creating-directories-tree.sh
./creating-essential-files-and-symlinks.sh

# collect packages
./rev.sh
./libstdc++-pass-2.sh
./gettext.sh
./bison.sh
./perl.sh
./python3.sh
./texinfo.sh
./util-linux.sh
./cleaning-up-temporary-system.sh

###
# Exit the chroot environment and run as user root
###
EOT
rm $LFS/*.sh
./mount-virtual-kernel-file-systems.sh --umount
./stripping.sh


echo "stage 2 complete"
