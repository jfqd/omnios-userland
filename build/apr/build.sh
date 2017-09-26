#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=apr
VER=1.6.2
PKG=custom/library/apr
SUMMARY="$PROG - Apache Portable Runtime"
DESC="$SUMMARY"

DEPENDS_IPS="library/libxml2 custom/library/uuid"

PLATFORM=`uname -p`
if [[ $PLATFORM == 'i386' ]]; then
    LAYOUT32=omni32
    LAYOUT64=omni64
else
    LAYOUT32=omnisparc32
    LAYOUT64=omnisparc64
fi

CPPFLAGS="$CPPFLAGS -I./include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"
CFLAGS="$CFLAGS -I./include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"
#LDFLAGS32=""
LDFLAGS64="-m64"

CONFIGURE_OPTS="--enable-nonportable-atomics
    --enable-threads
"
CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32
    --enable-layout=$LAYOUT32 \
    --with-installbuilddir=/usr/local/share/$ISAPART/build-1"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --enable-layout=$LAYOUT64 \
    --with-installbuilddir=/usr/local/share/$ISAPART64/build-1"

copy_config_layout() {
    logmsg "Copying config layout"
    cp $SRCDIR/files/config.layout $TMPDIR/$BUILDDIR/config.layout || \
        logerr "--- Failed to copy config.layout"
}

hack_libtool() {
    gsed -i -e 's/CC -shared/CC -m64 -shared/g;' $DESTDIR/usr/local/share/amd64/build-1/libtool
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
copy_config_layout
build
make_isa_stub
hack_libtool
make_package
clean_up
