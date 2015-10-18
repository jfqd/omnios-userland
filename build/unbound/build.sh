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

# https://unbound.net/downloads/unbound-1.5.5.tar.gz
PROG=unbound
VER=1.5.5
PKG=service/network/unbound
SUMMARY="$PROG - A validating, recursive, and caching DNS resolver."
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="system/library/gcc-4-runtime custom/library/libexpat library/libevent"

USER=unbound
GROUP=unbound

MAKE=/usr/bin/make

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-unbound.xml \
        $DESTDIR/lib/svc/manifest/network/unbound.xml
}

default_config() {
    logmsg "Copying default configuration files from ${SRCDIR} to ${DESTDIR}"
    logcmd cp $SRCDIR/files/root.hints $DESTDIR/usr/local/etc/unbound/root.hints
    logcmd mkdir -p $DESTDIR/usr/local/etc/unbound/keys
    logcmd touch $DESTDIR/usr/local/etc/unbound/unbound.log
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
default_config
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
