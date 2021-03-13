#! /bin/bash
function pause(){
 read -s -n 1 -p "Check to see if it worked."
 echo ""
}
# install the 'removepkg' utility as root
cp -v removepkg /mnt/lfs/sbin/
chown root:root /mnt/lfs/sbin/removepkg
chmod 744       /mnt/lfs/sbin/removepkg

###
# Go to the chroot environment
cp *.sh $LFS

./mount-virtual-kernel-file-systems.sh --mount
#hopefully this fixes the build issue
echo 'export PATH=/bin:/usr/bin:/sbin:/usr/sbin' >>/mnt/lfs/root/.bashrc
./entering-chroot-env.sh <<"EOT"
###
chmod 744 *.sh
./main-directory-tree.sh
pause
./kernel-headers.sh
pause
./man-pages.sh
pause
./iana-etc.sh
pause
./glibc.sh
pause
./zlib.sh
pause
./bzip2.sh
pause
./xz.sh
pause
./zstd.sh
pause
./file.sh
pause
./readline.sh
pause
./m4.sh
pause
./bc.sh
pause
./flex.sh
pause
./tcl.sh
pause
./expect.sh
pause
./dejagnu.sh
pause
./binutils.sh
pause
./gmp.sh
pause
./mpfr.sh
pause
./mpc.sh
pause
./attr.sh
pause
./acl.sh
pause
./libcap.sh
pause
./shadow.sh
pause
./gcc.sh
pause
./check-compiling-and-linking.sh
pause
./pkg-config.sh
pause
./ncurses.sh
pause
./sed.sh
pause
./psmisc.sh
pause
./gettext.sh
pause
./bison.sh
pause
./grep.sh
pause
./bash.sh
pause
./libtool.sh
pause
./gdbm.sh
pause
./gperf.sh
pause
./expat.sh
pause
./inetutils.sh
pause
./perl.sh
pause
./xml-parser.sh
pause
./intltool.sh
pause
./autoconf.sh
pause
./automake.sh
pause
./kmod.sh
pause
./libelf.sh
pause
./libffi.sh
pause
./openssl.sh
pause
./python3.sh
pause
./ninja.sh
pause
./meson.sh
pause
./coreutils.sh
pause
./check.sh
pause
./diffutils.sh
pause
./gawk.sh
pause
./findutils.sh
pause
./groff.sh
pause
./grub.sh
pause
./less.sh
pause
./gzip.sh
pause
./iproute2.sh
pause
./kbd.sh
pause
./libpipeline.sh
pause
./make.sh
pause
./patch.sh
pause
./man-db.sh
pause
./tar.sh
pause
./texinfo.sh
pause
./vim.sh
pause
./eudev.sh
pause
./procps-ng.sh
pause
./util-linux.sh
pause
./e2fsprogs.sh
pause
./sysklogd.sh
pause
./sysvinit.sh
pause
./stripping.sh
pause
./cleaning-up.sh
pause
EOT
rm $LFS/*.sh
echo "stage 3 complete"