#! /bin/bash

PRGNAME="pkg-config"

### Pkg-config (system for managing library compile/link flags)
# Инструмент для передачи путей include и/или путей к библиотекам для создания
# инструментов во время настройки и выполнения файлов

# http://www.linuxfromscratch.org/lfs/view/stable/chapter08/pkg-config.html

# Home page: https://www.freedesktop.org/wiki/Software/pkg-config

ROOT="/"
source "${ROOT}check_environment.sh"                  || exit 1
source "${ROOT}unpack_source_archive.sh" "${PRGNAME}" || exit 1

TMP_DIR="/tmp/pkg-${PRGNAME}-${VERSION}"
rm -rf "${TMP_DIR}"
mkdir -pv "${TMP_DIR}"

# указывает pkg-config использовать свою внутреннюю версию Glib, потому что
# внешняя версия недоступна в сборке LFS
#    --with-internal-glib
# опция отключает создание нежелательной жесткой ссылки на утилиту pkg-config
#    --disable-host-tool
./configure                    \
    --prefix=/usr              \
    --with-internal-glib       \
    --disable-host-tool        \
    --docdir="/usr/share/doc/${PRGNAME}-${VERSION}" || exit 1

make || make -j1 || exit 1
# make check
make install DESTDIR="${TMP_DIR}"

/bin/cp -vR "${TMP_DIR}"/* /

cat << EOF > "/var/log/packages/${PRGNAME}-${VERSION}"
# Package: ${PRGNAME} (system for managing library compile/link flags)
#
# pkg-config is a system for managing library compile/link flags that works
# with automake and autoconf. It replaces the ubiquitous *-config scripts you
# may have seen with a single tool. Package contains a tool for passing the
# include path and/or library paths to build tools during the configure and
# make file execution.
#
# Home page: https://www.freedesktop.org/wiki/Software/${PRGNAME}
# Download:  https://pkg-config.freedesktop.org/releases/${PRGNAME}-${VERSION}.tar.gz
#
EOF

source "${ROOT}write_to_var_log_packages.sh" \
    "${TMP_DIR}" "${PRGNAME}-${VERSION}"
