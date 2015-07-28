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

PROG=pflogsumm
VER=1.1.5
VERHUMAN=$VER
PKG=perl/pflogsumm
SUMMARY="provide an over-view of postfix activity to administrators"
DESC="pflogsumm.pl is designed to provide an over-view of postfix activity, with just enough detail to give the administrator a heads up for potential trouble spots"


DEPENDS_IPS="omniti/perl/date-calc"

build() {
  logcmd mkdir -p $DESTDIR/usr/local/bin
  logcmd mkdir -p $DESTDIR/usr/local/man/man1/
  logcmd cp $TMPDIR/$BUILDDIR/pflogsumm.pl $DESTDIR/usr/local/bin/pflogsumm.pl
  logcmd cp $TMPDIR/$BUILDDIR/pflogsumm.1  $DESTDIR/usr/local/man/man1/pflogsumm.1
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
# make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
