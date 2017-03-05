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

# https://github.com/hyperrealm/libconfig/archive/v1.6.tar.gz
PROG=libconfig
VER=1.6
VERHUMAN=$VER
PKG=library/libconfig
SUMMARY="C/C++ library for processing configuration files"
DESC="$SUMMARY ($VER)"


build32() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logmsg "Building 32-bit"
    export ISALIST="$ISAPART"
    make_clean
    configure32
    logcmd $MAKE $MAKE_JOBS
    logcmd rm $TMPDIR/$BUILDDIR/lib/scanner.{c,h}
    make_prog32
    make_install32
    popd > /dev/null
    unset ISALIST
    export ISALIST
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build

logcmd rm -rf $DESTDIR/usr/local/share/info/dir

make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: