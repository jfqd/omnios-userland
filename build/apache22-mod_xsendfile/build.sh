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

# https://tn123.org/mod_xsendfile/
PROG=mod_xsendfile
VER=0.12
VERHUMAN=$VER
PKG=custom/server/apache22/mod_xsendfile
SUMMARY="mod_xsendfile Apache2 module that processes X-SENDFILE headers"
DESC="mod_xsendfile is a small Apache2 module that processes X-SENDFILE headers registered by the original output handler."

build32() {
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logmsg "Building 32-bit"
  export ISALIST="$ISAPART"
  logcmd rm -rf ./.libs
  logcmd /usr/local/apache22/bin/i386/apxs -c mod_xsendfile.c
  logcmd mkdir -p $DESTDIR/usr/local/apache22/libexec/i386
  logcmd cp ./.libs/mod_xsendfile.so $DESTDIR/usr/local/apache22/libexec/i386/
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/modules/i386
  logcmd cp $SRCDIR/files/i386.load \
      $DESTDIR/usr/local/apache22/conf/modules/i386/mod_xsendfile.load
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/conf.d
  logcmd cp $SRCDIR/files/xsendfile.conf \
      $DESTDIR/usr/local/apache22/conf/conf.d/xsendfile.conf
  popd > /dev/null
  unset ISALIST
  export ISALIST
}

build64() {
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logmsg "Building 64-bit"
  logcmd rm -rf ./.libs
  logcmd /usr/local/apache22/bin/amd64/apxs -c mod_xsendfile.c
  logcmd mkdir -p $DESTDIR/usr/local/apache22/libexec/amd64
  logcmd cp ./.libs/mod_xsendfile.so $DESTDIR/usr/local/apache22/libexec/amd64/
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/modules/amd64
  logcmd cp $SRCDIR/files/amd64.load \
      $DESTDIR/usr/local/apache22/conf/modules/amd64/mod_xsendfile.load
  popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
#make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
