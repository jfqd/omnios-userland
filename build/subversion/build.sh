#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=subversion
VER=1.6.17
VERHUMAN=$VER
PKG=omniti/developer/versioning/subversion
SUMMARY="$PROG - An Open-Source Revision Control System"
DESC="$SUMMARY"

NEON=neon
NVER=0.30.1

BUILD_DEPENDS_IPS="developer/swig custom/server/apache22"
DEPENDS_IPS="custom/database/sqlite3 library/security/openssl 
             custom/library/apr custom/library/apr-util"

CFLAGS32="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"
CPPFLAGS32="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"

CONFIGURE_OPTS="$CONFIGURE_OPTS
    --sysconfdir=$PREFIX/etc
    --with-pic
    --with-ssl
    --without-perl
    --without-python
    --without-berkeley-db
    --without-jdk
    --disable-nls
    --with-sqlite=/usr/local"

CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32
    --with-apr=/usr/local/bin/$ISAPART/apr-1-config
    --with-apr-util=/usr/local/bin/$ISAPART/apu-1-config"

CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --with-swig=/usr/bin/local/$ISAPART64/swig
    --with-apr=/usr/local/bin/$ISAPART64/apr-1-config
    --with-apr-util=/usr/local/bin/$ISAPART64/apu-1-config"

CPPFLAGS="$CPPFLAGS -I/usr/local/include" 

LDFLAGS32="$LDFLAGS32 \
    -L/usr/local/lib -R/usr/local/lib"

LDFLAGS64="$LDFLAGS64 \
    -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"

# Extra script/file installs
add_file() {
    logmsg "--- $1"
    logcmd mkdir -p $DESTDIR$PREFIX/`dirname $2`
    logcmd cp $SRCDIR/$1 $DESTDIR$PREFIX/$2 || \
        logerr "Failed to copy $1 to $2"
    if [[ -n "$3" ]]; then
        logcmd chmod $3 $DESTDIR$PREFIX/$2
    else
        logcmd chmod 0444 $DESTDIR$PREFIX/$2
    fi
}

save_function download_source download_source_orig
download_source() {
    BUILDDIR=${NEON}-${NVER}
    download_source_orig $NEON $NEON $NVER
    BUILDDIR=${PROG}-${VER}
    download_source_orig $1 $2 $3
    logmsg "Copying neon to subversion source directory"
    logcmd cp -r ${TMPDIR}/${NEON}-${NVER} ${TMPDIR}/${PROG}-${VER}/neon || \
        logerr "Failed to copy neon"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: