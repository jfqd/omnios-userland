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
# Copyright 2016 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=lxml
VER=3.6.0
VERHUMAN=$VER
PKG=runtime/python27/lxml
DOWNLOADURL="https://github.com/lxml/lxml/archive/lxml-3.6.0.tar.gz"
SUMMARY="The lxml XML toolkit for Python"
DESC="$SUMMARY ($VER)"

BUILDARCH=32
PYTHON=/usr/local/bin/python2.7

DEPENDS_IPS="runtime/python27"
BUILD_DEPENDS_IPS="$DEPENDS_IPS"

# Cython need to be installed on the build machine
# pip install Cython

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
make_package
clean_up
