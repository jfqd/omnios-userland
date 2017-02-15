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

# https://github.com/extremeshok/clamav-unofficial-sigs
PROG=clamav-unofficial-sigs
VER=5.4.1
VERHUMAN=$VER
PKG=service/network/clamav-unofficial-sigs
SUMMARY="ClamAV Unofficial Signatures Updater"
DESC="$SUMMARY maintained by eXtremeSHOK.com"

DEPENDS_IPS="service/network/clamav"

build() {
  logmsg "Create Databases and copy files"
  logcmd mkdir -p $DESTDIR/usr/local/bin
  logcmd mkdir -p $DESTDIR/var/db/clamav-unofficial-sigs
  logcmd mkdir -p $DESTDIR/etc/clamav-unofficial-sigs
  logcmd cp $SRCDIR/files/clamav-unofficial-sigs.sh \
      $DESTDIR/usr/local/bin/clamav-unofficial-sigs
  logcmd cp $SRCDIR/files/master.conf \
      $DESTDIR/etc/clamav-unofficial-sigs
  logcmd cp $SRCDIR/files/os.conf \
      $DESTDIR/etc/clamav-unofficial-sigs
  logcmd cp $SRCDIR/files/user.conf \
      $DESTDIR/etc/clamav-unofficial-sigs
  logcmd touch $DESTDIR/var/log/clamav-unofficial-sigs.log
}

init
patch_source
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
