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

PROG=sphinx
VER=0.9.9
VERHUMAN=$VER
PKG=service/search/sphinx
SUMMARY="Full text search server"
DESC="Sphinx is an open source full text search server, designed from the ground up with performance, relevance (aka search quality), and integration simplicity in mind"

CONFIGURE_OPTS="--with-mysql-lib=/usr/local/lib \
    --with-mysql-includes=/usr/local/include/mysql"

BUILD_DEPENDS_IPS="library/unixodbc"
DEPENDS_IPS=$BUILD_DEPENDS_IPS

BUILDARCH=32

init
download_source $PROG $PROG $VER
patch_source
prep_build

# build fails with newer gcc
export PATH=/usr/local/bin:/usr/local/sbin:/usr/sfw/bin:/usr/gnu/bin:/usr/bin:/usr/sbin:/sbin:/bin
logcmd unset CC
logcmd unset CXX
logcmd unset CPP

build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
