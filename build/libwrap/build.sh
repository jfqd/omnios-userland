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

# http://ftp.porcupine.org/pub/security/tcp_wrappers_7.6-ipv6.4.tar.gz
PROG=libwrap
VER=7.6
RELEASE=ipv6.4
VERHUMAN=$VER
PKG=library/libwrap
SUMMARY="Socket Wrappers is an improved version of tcp_wrappers by Wietse Venema."
DESC="Socket wrappers for pre-screening tcp connections (ipv6.4 patched)"

BUILDDIR=tcp_wrappers_$VER-$RELEASE

MAKE="gmake"

# thanks to OpenCSW for the good work
# https://buildfarm.opencsw.org/source/xref/opencsw/csw/mgar/pkg/tcpwrappers/trunk/files/sharedlib.patch

export CC=/opt/gcc-4.8.1/bin/gcc
export REAL_DAEMON_DIR=/usr/local/sbin
export STYLE=-DPROCESS_OPTIONS
# export LIBS="-lsocket -lnsl"

build32() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logmsg "Building 32-bit"
    export ISALIST="$ISAPART"
    make_clean
    logcmd gmake sunos5-sharedext
    logcmd mkdir -p $DESTDIR/usr/local/lib/i386
    logcmd cp libwrap.so.1 $DESTDIR/usr/local/lib/i386/
    logcmd ln -s libwrap.so.1 $DESTDIR/usr/local/lib/i386/libwrap.so
    popd > /dev/null
    unset ISALIST
    export ISALIST
}

build64() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logmsg "Building 64-bit"
    make_clean
    export CFLAGS="-m64"
    logcmd gmake sunos5-sharedext64
    logcmd mkdir -p $DESTDIR/usr/local/lib/amd64
    logcmd cp libwrap.so.1 $DESTDIR/usr/local/lib/amd64/
    logcmd ln -s libwrap.so.1 $DESTDIR/usr/local/lib/amd64/libwrap.so
    popd > /dev/null
    unset CFLAGS
}

init
download_source tcp_wrappers $BUILDDIR
logcmd chmod u+w $BUILDDIR/*
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: