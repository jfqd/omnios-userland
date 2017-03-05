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

PROG=mosquitto
VER=1.4.11
VERHUMAN=$VER
PKG=service/network/mosquitto
SUMMARY="Mosquitto is implementation of the MQTT protocol"
DESC="Mosquitto is an open source implementation of a server for version 3.1 and 3.1.1 of the MQTT protocol"

BUILD_DEPENDS_IPS="library/libwrap
                   library/libwebsockets
                   library/libssh2
                   custom/library/uuid
                   library/c-ares"

DEPENDS_IPS="$BUILD_DEPENDS_IPS"

BUILDARCH=64
MAKE_JOBS=binary

export CC=/opt/gcc-4.8.1/bin/gcc
export CFLAGS="-m64"
export LDFLAGS="-m64 -R/usr/local/lib/amd64 -L/usr/local/lib/amd64 -lcares"

configure64() {
  logmsg "Skip configure script"
}

make_install() {
    logcmd mkdir -p $DESTDIR/var/lib/mosquitto
    logmsg "--- make install (with fake man pages)"
    # use http://mosquitto.org/man/ instead!
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto.8
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto.conf.5
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto_passwd.1
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto_pub.1
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto_sub.1
    logcmd touch $TMPDIR/$BUILDDIR/man/mosquitto-tls.7
    logcmd touch $TMPDIR/$BUILDDIR/man/mqtt.7
    logcmd touch $TMPDIR/$BUILDDIR/man/libmosquitto.3
    logcmd $MAKE DESTDIR=${DESTDIR} install || \
        logerr "--- Make install failed"
    logmsg "--- remove fake man pages in $DESTDIR/usr/local/share"
    if [ -n $DESTDIR ]; then
      logcmd rm -rf $DESTDIR/usr/local/share || \
        logerr "--- Remove fake man pages failed"
    else
      logerr "--- Remove fake man pages failed, empty DESTDIR variable"
    fi
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: