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

PROG=phpredis
VER=2.2.8
VERHUMAN=$VER
PKG=runtime/php56/php-phpredis
SUMMARY="A PHP extension for Redis"
DESC="$SUMMARY ($VER)"

BUILDARCH=64
PREFIX=$PREFIX/php56

BUILD_DEPENDS_IPS="runtime/php56"

CPPFLAGS="-I/usr/local/include"
LDFLAGS="-L/usr/local/lib -R/usr/local/lib \
    -L$PREFIX/lib -R$PREFIX/lib"

CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 \
    -L$PREFIX/lib -R$PREFIX/lib"

run_phpize() {
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logmsg "Run phpize"
  /usr/local/php56/bin/phpize
  popd > /dev/null
}

make_install64() {
  logmsg "--- make install"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
run_phpize
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
