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

# https://repo.varnish-cache.org/source/varnish-3.0.7.tar.gz
PROG=varnish
VER=3.0.7
VERHUMAN=$VER
PKG=service/network/varnish
SUMMARY="Fast Web HTTP Cache Proxy"
DESC="Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy"

DEPENDS_IPS="custom/library/pcre library/pkgconf"

BUILDARCH=64
#CFLAGS="-m64"
export PCRE_LIBS="-L/usr/lib/amd64 -lpcre"
export PCRE_CFLAGS="-I/usr/include/pcre"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build

logcmd mkdir -p $DESTDIR/etc/varnish/
logcmd touch $DESTDIR/etc/varnish/varnish.vcl
logcmd mkdir -p $DESTDIR/lib/svc/method
logcmd cp $SRCDIR/files/http-varnish $DESTDIR/lib/svc/method/http-varnish
logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
logcmd cp $SRCDIR/files/manifest-varnish.xml $DESTDIR/lib/svc/manifest/network/varnish.xml

make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
