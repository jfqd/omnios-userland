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

PROG=kamailio
VER=4.3
VERHUMAN=$VER
PKG=service/network/kamailio
SUMMARY="Open Source SIP Server"
DESC="Open Source SIP Server released under GPL, able to handle thousands of call setups per second."

BUILDARCH=32

export PREFIX="/usr/local"
export LD_LIBRARY_PATH="/usr/local/lib"

DEPENDS_IPS="library/libmysqlclient18"

download_source() {
  logcmd mkdir -p $TMPDIR/$BUILDDIR
  logcmd git clone --depth 1 --no-single-branch git://git.kamailio.org/kamailio $TMPDIR/$BUILDDIR
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logcmd git checkout -b 4.3 origin/4.3
  popd > /dev/null
}

patch_source() {
  logcmd sed -i -e "s#%expect 6#/*%expect 6*/#g" $TMPDIR/$BUILDDIR/cfg.y
}

build() {
  logmsg "--- Switch into builddir: $TMPDIR/$BUILDDIR"
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logcmd /usr/gnu/bin/make cfg include_modules='db_mysql tls'
  logcmd /usr/gnu/bin/make proper
  logcmd /usr/gnu/bin/make clean
  logcmd /usr/gnu/bin/make INSTALL=install all
  logmsg "--- Install into: $DESTDIR$PREFIX"
  logcmd /usr/gnu/bin/make prefix=$PREFIX basedir=$DESTDIR install
  popd > /dev/null
}

init
download_source
patch_source
prep_build
build
# make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: