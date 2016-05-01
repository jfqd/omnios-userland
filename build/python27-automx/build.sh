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

PROG=automx
VER=0.10.2
VERHUMAN=$VER
PKG=runtime/python27/automx
DOWNLOADURL="https://github.com/sys4/automx/archive/v0.10.2.tar.gz"
SUMMARY="mail client account configuration service"
DESC="automx is a $SUMMARY ($VER)"

BUILDARCH=32
PYTHON=/usr/local/bin/python2.7

DEPENDS_IPS="runtime/python27 python27/lxml python27/mysql python27/m2mcrypto"
BUILD_DEPENDS_IPS="runtime/python27"

# Additionally we need the following libraries.
# Later we will build a package for each.
#
# pip install python-dateutil ipaddr python-memcached python-sqlalchemy

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
make_package
clean_up
