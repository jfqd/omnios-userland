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

PROG=pound
VER=2.7
TARVER=2.8.a
VERHUMAN=$VER
PKG=network/pound27
SUMMARY="Reverse proxy, load balancer and HTTPS front-end"
DESC="The Pound program is a reverse proxy, load balancer and HTTPS front-end for Web server(s)"

USER=`/usr/bin/whoami`
PREFIX=/usr/local/pound27
BUILDDIR=pound-$TARVER

CONFIGURE_OPTS="--with-owner=${USER} \
    --with-group=${USER} \
    --prefix=${PREFIX} \
    --exec-prefix=${PREFIX} \
    --sysconfdir=/etc/pound27"

CXXFLAGS="-I/usr/include/pcre"
LDFLAGS="-L/usr/include/pcre -R/usr/include/pcre"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd mkdir -p $DESTDIR/etc/pound27
    logcmd mkdir -p $DESTDIR/etc/pound27/certs
    logcmd touch $DESTDIR/etc/pound27/pound.cfg
    logcmd cp $SRCDIR/files/manifest-pound.xml \
        $DESTDIR/lib/svc/manifest/network/pound.xml
}

init
download_source $PROG $PROG $TARVER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: