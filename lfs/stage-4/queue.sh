#! /bin/bash

###
# Переходим в chroot окружение
cp *.sh $LFS
./entering-chroot-env.sh <<"EOT"
###
./lfs-bootscripts.sh
./network-configuration.sh
## ./terminus-font.sh
./system-v-configuration.sh
./etc-profile.sh
./etc-inputrc.sh
./etc-shells.sh
EOT
rm $LFS/*.sh

echo "stage 4 complete"
