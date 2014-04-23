#!/bin/bash

set -e

function on_exit() {
    [ -e ${TEMPDIR} ] && rm -rf ${TEMPDIR}
}

BUILD_NUMBER=$(printf "%05d" ${BUILD_NUMBER:-$(date +%Y%m%d%H%M)})
BASE_DIR=$(readlink -f $(dirname $0))
profile=${1:-zvm-zpipes}

if [ ! -f ${BASE_DIR}/${profile}/manifest.txt ]; then
    echo "Cannot find profile: (${profile}/manifest.txt missing)"
    exit 1
fi

TEMPDIR=$(mktemp -d --tmpdir bundler-XXXXXXXXXXX)
# trap on_exit exit

OLD_PKG_CONFIG_PATH=${PKG_CONFIG_PATH}
export PKG_CONFIG_PATH=${TEMPDIR}/${profile}-${BUILD_NUMBER}/lib/pkgconfig:${OLD_PKG_CONFIG_PATH}

while read repo branch; do
    project=$(basename ${repo})
    echo -e "\n######################################################"
    echo "Building ${project}"
    echo -e "######################################################\n"

    git clone ${repo} ${TEMPDIR}/${project}
    pushd ${TEMPDIR}/${project}

    git checkout ${branch}

    if [ -x autogen.sh ]; then 
        ./autogen.sh
    else
        autoreconf -fi
    fi

    DESTDIR=${TEMPDIR}/${profile}-${BUILD_NUMBER}

    ./configure CFLAGS=-I${DESTDIR}/include LDFLAGS=-L${DESTDIR}/lib --prefix=''
    make
    # make check
    make DESTDIR=${DESTDIR} install

    # whack the .la files
    find ${DESTDIR} -name "*la" -exec rm {} \;

done < <( grep -v "^#" ${BASE_DIR}/${profile}/manifest.txt )

rm -rf "${DESTDIR}/etc"
rm -rf "${DESTDIR}/init"

cp -a "${BASE_DIR}/${profile}/etc" "${DESTDIR}"
cp -a "${BASE_DIR}/${profile}/init" "${DESTDIR}"

tar -C ${TEMPDIR} -czvf ${BASE_DIR}/${profile}-${BUILD_NUMBER}.tar.gz ${profile}-${BUILD_NUMBER}

