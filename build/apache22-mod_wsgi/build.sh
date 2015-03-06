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

PROG=mod_wsgi
VER=4.4.9
VERHUMAN=$VER
PKG=custom/server/apache22/mod_wsgi
SUMMARY="Python WSGI adapter module for Apache 2.2"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="custom/server/apache22"
DEPENDS_IPS="pkg://omnios/runtime/python-26 system/library/gcc-4-runtime"

PREFIX=/opt/apache22/

TAR=/usr/gnu/bin/tar

CFLAGS32="$CFLAGS32 -I/usr/include/python2.6"
CFLAGS64="$CFLAGS64 -I/usr/include/python2.6 -I/usr/include/amd64/python2.6"

LDFLAGS32="-L/usr/lib/python2.6 -R/usr/lib/python2.6 $LDFLAGS"
LDFLAGS64="-L/usr/lib/python2.6/amd64 -R/usr/lib/python2.6/adm64 -L/usr/lib/python2.6 -R/usr/lib/python2.6 $LDFLAGS"

CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32 --with-apxs=/usr/local/apache22/bin/$ISAPART/apxs --with-python=/usr/bin/python2.6"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64 --with-apxs=/usr/local/apache22/bin/$ISAPART64/apxs --with-python=/usr/bin/amd64/python2.6"

# Redefine the build32 to build all MPMs
save_function build32 build32_orig

build32() {
    build32_orig
    logcmd mv $DESTDIR/usr/local/apache22/libexec/amd64 \
        $DESTDIR/usr/local/apache22/libexec/i386
    logcmd cp $DESTDIR/usr/local/apache22/libexec/i386/mod_wsgi.so \
        $DESTDIR/usr/local/apache22/libexec
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
# make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: