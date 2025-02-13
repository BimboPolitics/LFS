#!/bin/bash

./binutils-pass-1.sh
./gcc-pass-1.sh
./kernel-headers.sh
./glibc.sh
./check-compiling-and-linking.sh
./libstdc++-pass-1.sh

###
# Cross-compiling temporary tools
###
# The following utilities are installed in their final location, but not yet
# can be used because at their arrangement will be used already
# new libraries and compiled programs installed on the LFS system will be
# find them later only in the chroot environment
###
./m4.sh
./ncurses.sh
./bash.sh
./coreutils.sh
./diffutils.sh
./file.sh
./findutils.sh
./gawk.sh
./grep.sh
./gzip.sh
./make.sh
./patch.sh
./sed.sh
./tar.sh
./xz.sh
./binutils-pass-2.sh
./gcc-pass-2.sh

echo "toolchain complete proceed to the next step"
