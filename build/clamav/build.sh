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

# http://www.clamav.net/downloads/production/clamav-0.99.2.tar.gz
# http://www.clamav.net/downloads/production/clamav-0.99.2.tar.gz.sig
PROG=clamav
VER=0.99.2
VERHUMAN=$VER
PKG=service/network/clamav
SUMMARY="ClamAV is an open source antivirus engine"
DESC="$SUMMARY ($VER)"

BUILDARCH=64
BUILD_DEPENDS_IPS=""
DEPENDS_IPS="system/library/gcc-4-runtime"

CONFIGURE_OPTS="--sysconfdir=/etc/$PROG
                --localstatedir=/var/$PROG
                --mandir=$PREFIX/share/man"

add_smf_support() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-clamav.xml \
        $DESTDIR/lib/svc/manifest/network/clamav.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/clamav \
        $DESTDIR/lib/svc/method/clamav
    logmsg "Create Database dir"
    logcmd mkdir -p $DESTDIR/usr/local/share/clamav
    logmsg "Create run dir"
    logcmd mkdir -p $DESTDIR/var/run/clamd
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_smf_support
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
