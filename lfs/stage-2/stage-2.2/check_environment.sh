#! /bin/bash

if [[ "$(id -u)" != "0" ]]; then
    echo "Only superuser (root) can run this script"
    exit 1
fi

# are we in a chroot environment?
ID1="$(awk '$5=="/" {print $1}' < /proc/1/mountinfo)"
ID2="$(awk '$5=="/" {print $1}' < /proc/$$/mountinfo)"
if [[ "${ID1}" == "${ID2}" ]]; then
    echo "You must enter chroot environment"
    echo "Run ./entering-chroot-env.sh"
    exit 1
fi

if [[ "${PATH}" != "/bin:/usr/bin:/sbin:/usr/sbin" ]]; then
    echo "Environment variable PATH musb be: /bin:/usr/bin:/sbin:/usr/sbin"
    echo ""
    echo "Now PATH=${PATH}"
    echo ""
    echo "Check script entering-chroot-env.sh"
    exit 1
fi
