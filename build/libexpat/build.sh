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

# http://downloads.sourceforge.net/project/expat/expat/2.2.1/expat-2.2.1.tar.bz2
# https://github.com/libexpat/libexpat/archive/R_2_2_1.tar.gz
PROG=libexpat
VER=2.2.1
VERHUMAN=$VER
PKG=custom/library/libexpat
SUMMARY="XML parser library"
DESC="James Clark's Expat XML parser library in C. It is a stream oriented parser that requires setting handlers to deal with the structure that the parser discovers in the document."

BUILDDIR=expat-$VER

init
download_source $PROG expat $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
