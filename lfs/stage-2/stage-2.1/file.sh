#! /bin/bash

PRGNAME="file"

### File
# Утилита для определения типа файла

source "$(pwd)/check_environment.sh"                  || exit 1
source "$(pwd)/unpack_source_archive.sh" "${PRGNAME}" || exit 1

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd || exit 1

./configure --prefix=/usr --host="${LFS_TGT}" --build=$(./config.guess) || exit 1

make FILE_COMPILE=$(pwd)/build/src/file || make -j1 || exit 1
make install DESTDIR="${LFS}"
