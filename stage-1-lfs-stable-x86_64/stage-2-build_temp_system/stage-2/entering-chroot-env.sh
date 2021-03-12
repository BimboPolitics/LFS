#! /bin/bash

# enter the chroot environment

LFS="/mnt/lfs"

if [[ "$(whoami)" != "root" ]]; then
    echo "Only superuser (root) can run this script"
    exit 1
fi

if ! mount | /bin/grep -q "${LFS}/proc"; then
    echo "You need to mount virtual file systems. Run script:"
    echo "  # ./mount-virtual-kernel-file-systems.sh --mount"
    exit 1
fi

RED="\[\033[1;31m\]"
MAGENTA="\[\033[1;35m\]"
RESETCOLOR="\[\033[0;0m\]"


# the -i option to env command will remove all environment variables except those set explicitly
chroot "${LFS}" /usr/bin/env -i                                           \
    HOME="/root"                                                          \
    TERM="${TERM}"                                                        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin                                    \
    PS1="\u ${MAGENTA}[LFS chroot]${RESETCOLOR}:${RED}\w\$${RESETCOLOR} " \
    /bin/bash --login +h

# from now on it is no longer necessary to use the $ {LFS} variable,
# because all work will be limited to the LFS file system, i.e. $ {LFS}
# will be the root of the filesystem


### NOTE:
# On first login to lfs at prompt instead of bash username
# will say "I have no name!". This is ok because the /etc/passwd file is not yet
# created.
