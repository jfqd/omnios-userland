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
# Copyright 1995-2013 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=pango
VER=1.30.1
VERHUMAN=$VER
PKG=library/pango
SUMMARY="Pango is a library for laying out and rendering of text"
DESC="Pango is a library for laying out and rendering of text, with an emphasis on internationalization. Pango can be used anywhere that text layout is needed, though most of the work on Pango so far has been done in the context of the GTK+ widget toolkit"         # Longer description, must be filled in
DOWNLOADURL=http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/pango-1.30.1.tar.xz
BUILDARCH=both

BUILD_DEPENDS_IPS="library/cairo"
RUN_DEPENDS_IPS="library/cairo"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
logcmd mkdir -p $DESTDIR/etc/pango
logcmd cp $SRCDIR/files/pango.modules  $DESTDIR/etc/pango
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
