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

# http://downloads.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.zip
# v8.37 was copied directly from svn repo with CVE-2015-3210 fix included
PROG=pcre
VER=8.38
VERHUMAN=$VER
PKG=custom/library/pcre
SUMMARY="Perl Compatible Regular Expressions"
DESC="The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5."

CONFIGURE_OPTS="--prefix=$PREFIX
    --enable-utf
    --enable-unicode-properties
    --enable-newline-is-anycrlf"

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
