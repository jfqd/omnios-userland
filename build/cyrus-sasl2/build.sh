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

PROG=cyrus-sasl2
VER=2.1.25
VERHUMAN=$VER
PKG=library/security/cyrus-sasl
SUMMARY="Simple Authentication and Security Layer library"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="system/library/gcc-4-runtime library/libpq5 database/bdb"

ARCHIVENAME=cyrus-sasl
BUILDDIR=$ARCHIVENAME-$VER
CONFIGURE_OPTS="--sysconfdir=/etc/sasl2
    --enable-shared=yes
    --enable-static=no
    --enable-gssapi=yes
    --enable-sql=yes
    --with-dbpath=/etc/sasl2/db"
CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32
    --with-pgsql=/usr/local/lib"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --with-pgsql=/usr/local/lib/$ISAPART64"

CFLAGS="$CFLAGS -I/usr/include/gssapi"


init
download_source $PROG $ARCHIVENAME $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: