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

PROG=nagios
VER=3.5.1
VERHUMAN=$VER
PKG=monitoring/nagios
SUMMARY="An Open Source system and network monitoring application"
DESC="$SUMMARY"

PREFIX=/usr/local/nagios
reset_configure_opts

# Path to perl to use for the embedded perl support
# PERLPATH32=/opt/OMNIperl/bin/$ISAPART
# PERLPATH64=/opt/OMNIperl/bin/$ISAPART64

BUILD_DEPENDS_IPS="library/gd library/libjpeg library/libpng incorporation/perl-516-incorporation runtime/perl"
DEPENDS_IPS="library/gd library/libjpeg library/libpng incorporation/perl-516-incorporation runtime/perl"

# Don't make a stub for p1.pl
NOSCRIPTSTUB=1

CPPFLAGS="-I/usr/local/include"
LDFLAGS32="$LDFLAGS32 -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"

CONFIGURE_OPTS="
    --with-nagios-user=$USER
    --with-nagios-group=users
    --with-httpd-conf=$PREFIX/etc
    --with-htmurl=
    --with-cgiurl=/cgi-bin
    --with-gd-inc=/usr/local/include
    --enable-embedded-perl
    --with-perlcache"

CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32
    --with-gd-lib=/usr/local/lib"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --with-gd-lib=/usr/local/lib/$ISAPART64"

make_prog() {
    logmsg "--- make"
    logmsg "------ make all"
    logcmd $MAKE all ||
        logerr "------ make all failed"
}

build() {
    ORIGPATH=$PATH
    if [[ $BUILDARCH == "32" || $BUILDARCH == "both" ]]; then
        export PATH=$PERLPATH32:$ORIGPATH
        build32
    fi
    if [[ $BUILDARCH == "64" || $BUILDARCH == "both" ]]; then
        export PATH=$PERLPATH64:$ORIGPATH
        build64
    fi
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
