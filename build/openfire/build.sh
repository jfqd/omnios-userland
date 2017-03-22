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

PROG=openfire
VER=4.1.3
VERHUMAN=$VER
PKG=network/openfire
SUMMARY="Openfire XMPP/Jabber Server"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="runtime/java"

build() {
  logcmd mkdir -p $DESTDIR/opt || logerr "cannot make /opt"
  logcmd mv $TMPDIR/$BUILDDIR $DESTDIR/opt/openfire \
      || logerr "cannot move distribution into place"
  logcmd mv $DESTDIR/opt/openfire/conf/openfire.xml $DESTDIR/opt/openfire/conf/openfire.xml.sample \
      || logerr "cannot move sample-config"
  logcmd cp $SRCDIR/openfire.xml $DESTDIR/opt/openfire/conf/ \
      || logerr "cannot install config"
  logcmd mkdir -p $DESTDIR/opt/openfire/var || logerr "cannot make var-dir"
  logcmd mkdir -p $DESTDIR/lib/svc/manifest/network \
      || logerr "cannot make SMF dir"
  logcmd chmod +x $DESTDIR/opt/openfire/bin/openfirectl
  logcmd cp $SRCDIR/smf-openfire.xml $DESTDIR/lib/svc/manifest/network/openfire.xml \
      || logerr "cannot install SMF manifest"
}

init
download_source $PROG $PROG $VER
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
