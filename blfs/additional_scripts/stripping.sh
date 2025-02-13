#! /bin/bash

BINARY="$(find "${TMP_DIR}" -type f -print0 | xargs -0 file 2>/dev/null | \
    grep -e "executable" -e "shared object" | grep ELF | cut -f 1 -d :)"

for BIN in ${BINARY}; do
    strip --strip-unneeded "${BIN}"
done
