#! /bin/bash
###
# IMPORTANT !!!
###
# Open the etc-fstab.sh script and check the variables
#    SWAP_PART  - points to a swap partition of a hard disk or to a swap file
#    ROOT_PART  - the root partition of the LFS system

###
# If /boot is on a separate partition on the host system, then the LFS kernel of the system
# should be set there. The easiest way to do this is
# mount /boot host to /boot directory of LFS system
# mount -v --bind /boot /mnt/lfs/boot
###

###
# Переходим в chroot окружение
cp *.sh $LFS
cp lfs-kernel-config-5.10.17 $LFS
./entering-chroot-env.sh <<"EOT"
###
./etc-fstab.sh
./etc-lfs-release.sh
./kernel-source.sh
./kernel-generic.sh 5.10.17
./kernel-modules.sh 5.10.17

EOT
rm $LFS/*.sh
rm $LFS/lfs-kernel-config-5.10.17
echo "stage 5 complete"

