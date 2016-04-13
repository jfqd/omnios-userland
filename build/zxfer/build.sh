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

PROG=zxfer
VER=1.1.6
VERHUMAN=$VER
PKG=service/backup/zxfer
DOWNLOADURL="https://github.com/allanjude/zxfer/archive/1.1.6.tar.gz"
SUMMARY="Script for managing ZFS snapshot replication"
DESC="$SUMMARY ($VER)"

TAR=gtar

build() {
  pushd $TMPDIR/$BUILDDIR > /dev/null
  logcmd mkdir -p $DESTDIR/usr/local/sbin
  logcmd cp zxfer $DESTDIR/usr/local/sbin/zxfer
  logcmd mkdir -p $DESTDIR/usr/local/share/man/man1m
  logcmd cp zxfer.1m $DESTDIR/usr/local/share/man/man1m/zxfer.1m
  popd > /dev/null
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
