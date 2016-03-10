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

# http://ftp.porcupine.org/pub/security/tcp_wrappers_7.6-ipv6.4.tar.gz
PROG=libwrap
VER=7.6
RELEASE=ipv6.4
VERHUMAN=$VER
PKG=library/libwrap
SUMMARY="Socket Wrappers is an improved version of tcp_wrappers by Wietse Venema."
DESC="Socket wrappers for pre-screening tcp connections (ipv6.4 patched)"

BUILDDIR=tcp_wrappers_$VER-$RELEASE

init
download_source tcp_wrappers $BUILDDIR
patch_source
prep_build

pushd $TMPDIR/$BUILDDIR > /dev/null
export CC=/opt/gcc-4.8.1/bin/gcc
logcmd gmake REAL_DAEMON_DIR=/usr/local/sbin STYLE=-DPROCESS_OPTIONS LIBS="-lsocket -lnsl" sunos5
logcmd mkdir -p $DESTDIR/usr/local/sbin
logcmd mkdir -p $DESTDIR/usr/local/lib
logcmd mkdir -p $DESTDIR/usr/local/include
logcmd mkdir -p $DESTDIR/usr/local/share/man/man3
logcmd mkdir -p $DESTDIR/usr/local/share/man/man5
logcmd mkdir -p $DESTDIR/usr/local/share/man/man8
logcmd cp try-from $DESTDIR/usr/local/sbin/
logcmd cp tcpdmatch $DESTDIR/usr/local/sbin/
logcmd cp tcpdchk $DESTDIR/usr/local/sbin/
logcmd cp tcpd $DESTDIR/usr/local/sbin/
logcmd cp safe_finger $DESTDIR/usr/local/sbin/
logcmd cp libwrap.a $DESTDIR/usr/local/lib/
logcmd cp hosts_access.3 $DESTDIR/usr/local/share/man/man3/
logcmd cp hosts_access.5 $DESTDIR/usr/local/share/man/man5/
logcmd cp hosts_options.5 $DESTDIR/usr/local/share/man/man5/
logcmd cp tcpdmatch.8 $DESTDIR/usr/local/share/man/man8/
logcmd cp tcpdchk.8 $DESTDIR/usr/local/share/man/man8/
logcmd cp tcpd.8 $DESTDIR/usr/local/share/man/man8/
logcmd cp tcpd.h $DESTDIR/usr/local/include/
popd > /dev/null

# build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: