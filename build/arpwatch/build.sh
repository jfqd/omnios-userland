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

PROG=arpwatch
VER=2.1a11
VERHUMAN=$VER
PKG=network/arpwatch
SUMMARY="the ethernet monitor program"
DESC="the ethernet monitor program; for keeping track of ethernet/ip address pairings"

BUILD_DEPENDS_IPS="system/library/pcap"
DEPENDS_IPS="system/library/pcap"

CONFIGURE_OPTS="--sysconfdir=/etc --localstatedir=/var"
BUILDARCH=32
CFLAGS="-std=c99"
USER=`/usr/bin/whoami`

build() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logmsg "Building 32-bit"
    export ISALIST="$ISAPART"
    make_clean
    configure32
    make_prog32
    logcmd /usr/gnu/bin/sed -i -e "s#-o bin -g bin#-o ${USER} -g ${USER}#g" Makefile
    logcmd mkdir -p $DESTDIR$PREFIX/sbin/i386
    logcmd mkdir -p $DESTDIR$PREFIX/var/arpwatch
    logcmd touch $DESTDIR$PREFIX/var/arpwatch/arp.dat
    make_install32
    logcmd mkdir -p $DESTDIR$PREFIX/share/man/man8
    logcmd cp arpsnmp.8 $DESTDIR$PREFIX/share/man/man8
    logcmd cp arpwatch.8 $DESTDIR$PREFIX/share/man/man8
    popd > /dev/null
    unset ISALIST
    export ISALIST
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
VER=${VER//[a]/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: