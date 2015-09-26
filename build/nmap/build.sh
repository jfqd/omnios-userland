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

PROG=nmap
VER=6.47
VERHUMAN=$VER
PKG=network/nmap
SUMMARY="utility for network discovery and security auditing"
DESC="Nmap (Network Mapper) is a free and open source (license) utility for network discovery and security auditing"

DEPENDS_IPS="developer/versioning/subversion custom/library/apr"

BUILDARCH=32

CONFIGURE_OPTS="--without-zenmap \
                --with-subversion=/usr/local/ \
                --with-libdnet=included \
                --with-liblua=included \
                --with-libpcap=included \
                --with-libpcre=included \
                --without-nmap-update \
                --with-openssl=/usr"

save_function configure32 configure32_orig
configure32() {
  configure32_orig
  # thanks to opencsw
  logcmd gsed -i -e 's;^/\* #undef HAVE_STREAMS_MIB2 \*/;#define HAVE_STREAMS_MIB2 1;' \
    $TMPDIR/$BUILDDIR/libdnet-stripped/include/config.h
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
