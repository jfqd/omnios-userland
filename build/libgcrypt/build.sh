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

# https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.7.tar.bz2
PROG=libgcrypt
VER=1.7.7
VERHUMAN=$VER
PKG=library/security/libgcrypt
SUMMARY="Libgcrypt is GNU's basic cryptographic library."
DESC="Libgcrypt is a general purpose cryptographic library based on the code from GnuPG. It provides functions for all cryptographic building blocks: symmetric ciphers, hash algorithms, MACs, public key algorithms, large integer functions, random numbers and a lot of supporting functions."

DEPENDS_IPS="library/security/libgpg-error"
BUILDARCH=32

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
# fix install issues with nano
logcmd mv $DESTDIR/usr/local/share/info/dir $DESTDIR/usr/local/share/info/dir.libgcrypt-bak
#
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
