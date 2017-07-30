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

# http://www.memcached.org/files/memcached-1.4.39.tar.gz
PROG=memcached
VER=1.4.39
VERHUMAN=$VER
PKG=server/memcached
SUMMARY="$PROG - free & open source, high-performance, distributed memory object caching system"
DESC="$SUMMARY"

DEPENDS_IPS="library/libevent =library/libevent@2.0
             system/library/gcc-4-runtime"

copy_manifest() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/var/svc/manifest/application/database/
    logcmd cp $SRCDIR/files/memcached.xml \
        $DESTDIR/var/svc/manifest/application/database/memcached.xml
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
copy_manifest
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
