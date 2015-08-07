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

PROG=logwatch
VER=7.4.1
VERHUMAN=$VER
PKG=monitoring/logwatch
SUMMARY="Logwatch is a customizable log analysis system."
DESC="Logwatch is a customizable log analysis system. Logwatch parses through your system's logs and creates a report analyzing areas that you specify. Logwatch is easy to use and will work right out of the package on most systems."

init
download_source $PROG $PROG $VER
patch_source
prep_build

logcmd chmod +x $TMPDIR/$BUILDDIR/install_logwatch.sh
logcmd cd $TMPDIR/$BUILDDIR ; ./install_logwatch.sh --prefix $DESTDIR
# https://buildfarm.opencsw.org/source/xref/opencsw/csw/mgar/pkg/logwatch/trunk/Makefile

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
