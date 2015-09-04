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

PROG=mod_ssl
VER=2.2.31
VERHUMAN=$VER
PKG=custom/server/apache22/mod_ssl
SUMMARY="Strong cryptography for the Apache webserver"
DESC=$SUMMARY

BUILD_DEPENDS_IPS="custom/database/sqlite3 \
    library/security/openssl \
    custom/library/apr \
    custom/library/apr-util"

DEPENDS_IPS=$BUILD_DEPENDS_IPS

PREFIX=/usr/local/apache22

BUILDARCH=32
ARCHIVENAME=httpd
BUILDDIR=$ARCHIVENAME-$VER

CONFIGURE_OPTS="--prefix=$PREFIX
    --enable-layout=Soli386
    --enable-ssl
    --enable-mods-shared=all
    --with-apr=/usr/local/bin/i386/apr-1-config
    --with-apr-util=/usr/local/bin/i386/apu-1-config"

# reset_configure_opts

# Add some more files once the source code has been downloaded
save_function download_source download_source_orig
download_source() {
    download_source_orig "$@"
    logcmd cp $SRCDIR/files/config.layout $TMPDIR/$BUILDDIR/
}

configure() {
    logmsg "--- configure (32-bit)"
    CFLAGS="$CFLAGS $CFLAGS32" \
    CXXFLAGS="$CXXFLAGS $CXXFLAGS32" \
    CPPFLAGS="$CPPFLAGS $CPPFLAGS32" \
    LDFLAGS="$LDFLAGS $LDFLAGS32" \
    CC=$CC CXX=$CXX \
    logcmd $CONFIGURE_CMD $CONFIGURE_OPTS || \
        logerr "--- Configure failed"
}

build() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logmsg "Building 32-bit"
    export ISALIST="$ISAPART"
    make_clean
    configure
    make_prog32
    
    logcmd mkdir $DESTDIR$PREFIX/libexec/i386
    logcmd cp $TMPDIR/$BUILDDIR/build/modules/ssl/.libs/mod_ssl.so $DESTDIR$PREFIX/libexec/i386
    
    popd > /dev/null
    unset ISALIST
    export ISALIST
}

init
download_source $ARCHIVENAME $ARCHIVENAME $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
