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
# Copyright 2013 Steffen Kram. All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

# https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.bz2
# https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.bz2.sig
# https://git.savannah.gnu.org/cgit/freetype/freetype2.git/snapshot/freetype2-master.tar.gz
PROG=freetype
VER=2.8
VERHUMAN=$VER
PKG=library/freetype2
SUMMARY="A Free, High-Quality, and Portable Font Engine"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="system/library/gcc-4-runtime library/libpng library/harfbuzz"

export GNUMAKE=gmake

CFLAGS="-I/usr/local/include"
LDFLAGS32="$LDFLAGS32 -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"

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
