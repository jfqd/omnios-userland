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

PROG=libnet
VER=1.1.6
VERHUMAN=$VER
PKG=library/libnet
DOWNLOADURL="https://github.com/sam-github/libnet/archive/libnet-1.1.6.tar.gz"
SUMMARY="libnet provides a portable framework for low-level network packet construction"
DESC="libnet provides a portable framework for low-level network packet construction ($VER)"

CFLAGS="-O0 -g -Wall"
CONFIGURE_OPTS="--with-pic --enable-maintainer-mode --enable-dependency-tracking --enable-shared=yes --with-gnu-ld"

MAKE=gmake

create_configure() {
  logmsg "Create configure file in $TMPDIR/$BUILDDIR/libnet"
  pushd $TMPDIR/$BUILDDIR/libnet >/dev/null
  logcmd /usr/sfw/bin/autoreconf --install
  logcmd sed -i -e "s#define DLPI_DEV_PREFIX \"/dev\"#define DLPI_DEV_PREFIX \"/dev/net\"#g" ./src/libnet_link_dlpi.c
  popd >/dev/null
}

build32() {
    pushd $TMPDIR/$BUILDDIR/libnet > /dev/null
    logmsg "Building 32-bit"
    export ISALIST="$ISAPART"
    make_clean
    configure32
    make_prog32
    make_install32
    popd > /dev/null
    unset ISALIST
    export ISALIST
}

build64() {
    pushd $TMPDIR/$BUILDDIR/libnet > /dev/null
    logmsg "Building 64-bit"
    make_clean
    configure64
    make_prog64
    make_install64
    popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
create_configure
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: