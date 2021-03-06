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

# https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.6.tar.bz2
# SHA256: 07aa3ed3bffbfb97b6fc5296a86621e6bb5349c6f8e549bd0db7f61e3e210fd0
PROG=ruby
VER=2.3.6
MAIN_VER=2.3
VERHUMAN=$VER
PKG=runtime/ruby-2.3
SUMMARY="A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
DESC="$SUMMARY ($VER)"

BUILD_DEPENDS_IPS="custom/library/libffi custom/library/readline developer/build/autoconf"
DEPENDS_IPS="library/yaml"

PREFIX="$PREFIX/$PROG/$MAIN_VER"

# Ruby doesn't have the concept of library paths,
#   so only one arch can be installed in $PREFIX
# Default to 64-bit
[[ "$BUILDARCH" == "both" ]] && BUILDARCH=64

CONFIGURE_OPTS="--prefix=$PREFIX \
    --enable-shared \
    --disable-install-doc \
    ac_cv_func_dl_iterate_phdr=no"

CONFIGURE_OPTS_32=
CONFIGURE_OPTS_64=

# https://bugs.ruby-lang.org/issues/10460
export CFLAGS="-O2"

init
download_source $PROG $PROG $VER
patch_source
prep_build
#run_autoconf
build
#make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
