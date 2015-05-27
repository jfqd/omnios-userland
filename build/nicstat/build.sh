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

PROG=nicstat
VER=1.95
VERHUMAN=$VER
PKG=network/nicstat
SUMMARY="Network traffic statics utility for Solaris and Linux"
DESC=$SUMMARY

BUILDDIR="$PROG-src-$VER"

init
download_source $PROG $PROG-src $VER
patch_source
prep_build

logcmd cd $TMPDIR/$BUILDDIR
logcmd $CC -g -O -D_REENTRANT -DUSE_DLADM nicstat.c -lsocket -lkstat -lrt -ldladm -o nicstat
logcmd /usr/bin/mkdir -p $DESTDIR/usr/local/bin
logcmd /usr/bin/cp $TMPDIR/$BUILDDIR/nicstat $DESTDIR/usr/local/bin/nicstat

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
