#! /bin/bash

# For the chroot environment to work properly, you need to establish a connection with a running
# the kernel using virtual filesystems. These filesystems are
# virtual, since they do not use disk space, and all of them
# the content is in memory:
#    /dev       - catalog /dev host
#    /dev/pts   - devpts
#    /proc      - proc
#    /run       - tmpfs
#    /sys       - sysfs

PART="/dev/sdb"
LFS="/mnt/lfs"

if [[ "$(whoami)" != "root" ]]; then
    echo "Only superuser (root) can run this script"
    exit 1
fi

usage() {
    echo "Usage: $0 <--mount|--umount>"
}

find_mnt() {
    findmnt | grep --color=auto "${LFS}"
}

case "$1" in
    --mount)
        ;;
    --umount)
        umount "${LFS}"/{dev{/pts,},proc,run,sys} &>/dev/null
        find_mnt
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
esac

# смонтируем LFS раздел
mount "${PART}" "${LFS}" &>/dev/null

! [ -d "${LFS}/dev" ] && mkdir -pv "${LFS}"/{dev/pts,proc,run,sys}

### Preparing the kernel virtual filesystem
# ----------------------------------------------
# When the kernel boots the system, it requires multiple device nodes,
# in particular consoles / dev / console and devices / dev / null. Device nodes
# must be created on your hard drive to be available prior to launch
# udevd and also when the kernel is started with the option init=/bin/bash

# if the directory $ {LFS} / dev is already mounted, unmount it
umount "${LFS}/dev/pts" &>/dev/null
umount "${LFS}/dev"     &>/dev/null


# create character devices /dev/console and /dev/null if they don't exist
! [ -e "${LFS}/dev/console" ] && \
    mknod -m 600 "${LFS}/dev/console" c 5 1
! [ -e "${LFS}/dev/null" ] && \
    mknod -m 666 "${LFS}/dev/null"    c 1 3

# the recommended method for filling the /dev directory with devices is to mount
# a virtual filesystem (like tmpfs) in the /dev directory and allow
# dynamically create devices on this virtual filesystem as
# discovering or accessing them. Device creation is usually done during
# time of the Udev boot process. Since our new system does not yet have Udev
# and not loaded yet, you need to mount and populate /dev manually. it
# achieved by mounting the ${LFS}/dev directory with the --bind option in
# the / dev directory of the host system. --bind is a special type of mount that
# allows us to create a mirror of a directory or mount point in some
# elsewhere, i.e. mirror of the host's /dev filesystem in the directory ${LFS}/dev
mount --bind /dev "${LFS}/dev" &>/dev/null

### Mounting the kernel virtual filesystem
# ------------------------------------------------
# Devices in /dev/pts - these are pseudo-terminal devices (pty). We mount
# /dev/pts host in /mnt/lfs/dev/pts
mount --bind /dev/pts "${LFS}/dev/pts" &>/dev/null

# proc, run, sys
if ! mount | /bin/grep -q "${LFS}/proc"; then
    mount -t proc  proc  "${LFS}/proc" &>/dev/null
fi

if ! mount | /bin/grep -q "${LFS}/run"; then
    mount -t tmpfs tmpfs "${LFS}/run"  &>/dev/null
fi

if ! mount | /bin/grep -q "${LFS}/sys"; then
    mount -t sysfs sysfs "${LFS}/sys"  &>/dev/null
fi


# on some host systems / dev / shm is a symbolic link to
# /run/shm, so in this case you need to create a directory /run/shm
if [ -h "${LFS}/dev/shm" ]; then
    mkdir -pv "${LFS}/$(readlink ${LFS}/dev/shm)"
fi

find_mnt
