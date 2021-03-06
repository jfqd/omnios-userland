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

PROG=boost
VER=1.49.0
TARVER=1_49_0
VERHUMAN=$VER
PKG=library/boost
SUMMARY="Free portable C++ libraries"
DESC="Boost provides free portable peer-reviewed C++ libraries. The emphasis is on portable libraries which work well with the C++ Standard Library."

BUILDDIR=boost_$TARVER

create_makefile() {
    logmsg "Create Makefile file in $TMPDIR/$BUILDDIR"
    logcmd cd $TMPDIR/$BUILDDIR ; ./bootstrap.sh --prefix=$DESTDIR --with-toolset=gcc
}

build_with_jam() {
    logmsg "Build Boost"
    logcmd cd $TMPDIR/$BUILDDIR ; ./b2 install
}

init
download_source $PROG $PROG $TARVER
patch_source
prep_build
create_makefile
build_with_jam
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: