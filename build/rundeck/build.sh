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

PROG=rundeck
VER=2.6.6
VERHUMAN=$VER
PKG=automation/rundeck
SUMMARY="Turn your operations procedures into self-service jobs"
DESC="Turn your operations procedures into self-service jobs. Safely give others the control and visibility they need."

DEPENDS_IPS="runtime/java"

build() {
  logcmd mkdir -p $DESTDIR/opt/rundeck \
      || logerr "cannot make /opt/rundeck"
  logcmd mv $TMPDIR/$BUILDDIR/rundeck-launcher-$VER.jar $DESTDIR/opt/rundeck/ \
      || logerr "cannot move distribution into place"
  logcmd mkdir -p $DESTDIR/lib/svc/method \
      || logerr "cannot make method dir"
  logcmd cp $SRCDIR/files/rundeck $DESTDIR/lib/svc/method/rundeck \
      || logerr "cannot make method dir"
  logcmd mkdir -p $DESTDIR/lib/svc/manifest/application \
      || logerr "cannot make SMF dir"
  logcmd cp $SRCDIR/files/smf-rundeck.xml $DESTDIR/lib/svc/manifest/application/rundeck.xml \
      || logerr "cannot install SMF manifest"
  logcmd sed -i -e "s#@VER@#${VER}#g" $DESTDIR/lib/svc/method/rundeck \
      || logerr "cannot set rundeck version"
}

init
download_source $PROG $PROG $VER
#patch_source
prep_build
build
#make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
