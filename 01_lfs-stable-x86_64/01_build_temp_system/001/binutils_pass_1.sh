#! /bin/bash

PRGNAME="binutils"

### Binutils
# Пакет содержит компоновщик, ассемблер и другие инструменты для работы с
# объектными файлами

# http://www.linuxfromscratch.org/lfs/view/stable/chapter05/binutils-pass1.html

# Home page: http://www.gnu.org/software/binutils/

###
# Это первый проход binutils
###

source "$(pwd)/check_environment.sh"                  || exit 1
source "$(pwd)/unpack_source_archive.sh" "${PRGNAME}" || exit 1

# документация Binutils рекомендует собирать binutils в отдельном каталоге
mkdir build
cd build || exit 1

### Конфигурация
# установка в каталог /tools
#    --prefix="${LFS}/tools"
# искать библиотеки целевой системы по мере необходимости в ${LFS}
#    --with-sysroot="${LFS}"
# поскольку описание компьютера в переменной LFS_TGT (x86_64-lfs-linux-gnu)
# немного отличается от значения, возвращаемого сценарием config.guess
# (x86_64-pc-linux-gnu), настроиваем систему сборки binutil для создания
# кросс-линкера
#    --target="${LFS_TGT}"
# отключаем интернационализацию, поскольку i18n не требуется для временных
# инструментов.
#    --disable-nls
# предотвращаем остановку сборки в случае появления предупреждений от
# компилятора хоста
#    --disable-werror
../configure                \
    --prefix=/tools         \
    --with-sysroot="${LFS}" \
    --target="${LFS_TGT}"   \
    --disable-nls           \
    --disable-werror || exit 1

make || make -j1 || exit 1
make install
