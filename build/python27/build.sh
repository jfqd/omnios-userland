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

PROG=Python
VER=2.7.12
VERHUMAN=$VER
PKG=runtime/python27
SUMMARY="Python is a programming language that lets you work quickly and integrate systems more effectively."
DESC=$SUMMARY
VERMAJOR=${VER%.*}

# system ffi is required for 64bit ctypes module
#BUILD_DEPENDS_IPS='library/libffi'

# CONFIGURE_OPTS="$CONFIGURE_OPTS --with-system-ffi --enable-shared --enable-unicode=ucs4"

# ncurses
#LDFLAGS64="$LDFLAGS64 -L/usr/gnu/lib/$ISAPART64 -R/usr/gnu/lib/$ISAPART64"
#CPPFLAGS="$CPPFLAGS -I/usr/include/ncurses"

BUILDARCH=32
NOSCRIPTSTUB=1
make_install64() {
    logmsg '--- make install'
    logcmd $MAKE DESTDIR=$DESTDIR DESTSHARED=${PREFIX}/lib/python${VERMAJOR}/lib-dynload install || logerr '--- make install failed'
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