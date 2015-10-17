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
PKG=
SUMMARY="Open Source SIP Server"
DESC="Open Source SIP Server released under GPL, able to handle thousands of call setups per second."

ADDITIONAL_MODULES="db_mysql tls"

BUILDARCH=32

export PREFIX="/usr/local/kamailio"
export LD_LIBRARY_PATH="/usr/local/lib"

DEPENDS_IPS="library/libmysqlclient18"

download_source() {
  logcmd mkdir -p $TMPDIR/$BUILDDIR
  logcmd git clone --depth 1 --no-single-branch git://git.kamailio.org/kamailio /$TMPDIR/$BUILDDIR/kamailio
}

patch_source() {
  logcmd sed -i -e "s#%expect 6#/*%expect 6*/#g" $TMPDIR/$BUILDDIR/cfg.y
}

build() {
  pushd $TMPDIR/$BUILDDIR/kamailio > /dev/null
  logcmd git checkout -b 4.3 origin/4.3
  logcmd make PREFIX=$PREFIX include_modules="$ADDITIONAL_MODULES" cfg
  logcmd make proper
  logcmd make clean
  logcmd make all
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
