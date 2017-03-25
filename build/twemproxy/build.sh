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

PROG=twemproxy
VER=0.4.1
VERHUMAN=$VER
PKG=service/network/twemproxy
SUMMARY="A fast, light-weight proxy for memcached and redis"
DESC="$SUMMARY ($VER)"

create_configure() {
  logmsg "Create configure file in $TMPDIR/$BUILDDIR/libnet"
  pushd $TMPDIR/$BUILDDIR >/dev/null
  logcmd /usr/sfw/bin/autoreconf -fvi
  popd >/dev/null
}

add_smf_support() {
  logmsg "Installing SMF"
  logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
  logcmd cp $SRCDIR/files/manifest-twemproxy.xml \
      $DESTDIR/lib/svc/manifest/network/twemproxy.xml
  logcmd mkdir -p $DESTDIR/var/log
  logcmd touch -p $DESTDIR/var/log/twemproxy.log
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
create_configure
build
add_smf_support
make_isa_stub
make_package
clean_up
