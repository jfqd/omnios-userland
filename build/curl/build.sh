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

# https://curl.haxx.se/download/curl-7.55.1.tar.bz2
# https://curl.haxx.se/download/curl-7.55.1.tar.bz2.asc
PROG=curl
VER=7.55.1
PKG=local/web/curl
SUMMARY="$PROG - command line tool for transferring data with URL syntax"
DESC="$SUMMARY"

DEPENDS_IPS="web/ca-bundle
             library/security/openssl
             local/library/zlib
             library/libidn
             library/libnet"

CONFIGURE_OPTS="--enable-thread --with-ca-bundle=/etc/ssl/cacert.pem"
# curl actually has arch-dependent headers. Boo.
CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32 --includedir=$PREFIX/include"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64 --includedir=$PREFIX/include/amd64"

LIBTOOL_NOSTDLIB=libtool

fix_isa_stub() {
    logcmd rm $DESTDIR/usr/local/bin/curl-config
    logcmd cp $DESTDIR/usr/local/bin/i386/curl-config $DESTDIR/usr/local/bin/curl-config
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
fix_isa_stub
make_package
clean_up
