#! /bin/bash

# вход в среду chroot

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

# опция -i для команды env удалит все переменные среды кроме установленных явно
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h
