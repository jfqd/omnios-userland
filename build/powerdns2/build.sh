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

PROG=powerdns
VER=2.9.22
VERHUMAN=$VER
PKG=service/network/powerdns2
SUMMARY="DNS Authoritative Server"
DESC="PowerDNS is a fast Authoritative DNS Server with a lot of backend and lua support"

BUILDARCH=32
BUILDDIR="pdns-$VER"

DEPENDS_IPS="library/libmysqlclient18"

# AR=/usr/bin/gar
export CFLAGS="-I/include -DSOLARIS -pthreads"
export LDFLAGS="-lsocket -lnsl"

CONFIGURE_OPTS="AR=/usr/bin/gar \
    --with-modules='gmysql' \
    --with-dynmodules='' \
    --localstatedir=/var/run \
    --enable-shared \
    --with-mysql-includes=/opt/csw/include/mysql \
    --with-mysql-lib=/opt/csw/lib \
    --with-boost=/include"

init
download_source $PROG pdns $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
