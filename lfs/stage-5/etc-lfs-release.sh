#! /bin/bash

PRGNAME="etc-lfs-release"
VERSION="stable"

### /etc/lfs-release (system info)
# /etc/lfs-release - содержит версию LFS системы
# /etc/lsb-release - информация о системе
# /etc/os-release  - информация о системе, которая используется systemd и
#                       некоторыми графическими средами рабочего стола

ROOT="/"
source "${ROOT}check_environment.sh"      || exit 1

TMP_DIR="/tmp/pkg-${PRGNAME}"
rm -rf "${TMP_DIR}"
mkdir -pv "${TMP_DIR}/etc"

echo "${VERSION}" > "${TMP_DIR}/etc/lfs-release"

cat << EOF > "${TMP_DIR}/etc/lsb-release"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="${VERSION}"
DISTRIB_CODENAME="BimboPolitics"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

cat << EOF > "${TMP_DIR}/etc/os-release"
NAME="Linux From Scratch"
VERSION="${VERSION}"
ID=lfs
PRETTY_NAME="Linux From Scratch ${VERSION}"
VERSION_CODENAME="BimboPolitics"
EOF

/bin/cp -vpR "${TMP_DIR}"/* /

cat << EOF > "/var/log/packages/${PRGNAME}"
# Package: ${PRGNAME} (system info)
#
# /etc/lfs-release
# /etc/lsb-release
# /etc/os-release
#
EOF

source "${ROOT}/write_to_var_log_packages.sh" \
    "${TMP_DIR}" "${PRGNAME}"
