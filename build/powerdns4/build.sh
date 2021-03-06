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

# https://downloads.powerdns.com/releases/pdns-4.0.4.tar.bz2
PROG=powerdns
VER=4.0.4
VERHUMAN=$VER
PKG=service/network/dns/powerdns4
SUMMARY="DNS Authoritative Server"
DESC="PowerDNS is a fast Authoritative DNS Server with a MySQL backend-, DNSSEC- and lua-support"

BUILDARCH=32
BUILDDIR="pdns-$VER"

DEPENDS_IPS="library/libmysqlclient18 runtime/lua library/boost"

# https://github.com/PowerDNS/pdns/issues/1876
AR=/usr/bin/gar
CC=/opt/gcc-4.8.1/bin/gcc
CXX=/opt/gcc-4.8.1/bin/g++
CPP=/opt/gcc-4.8.1/bin/cpp

CXXFLAGS="-I/include -I/usr/local/include/mysql"
LDFLAGS="-L/include -R/include -L/usr/local/lib -R/usr/local/lib -lsocket -lnsl -lcrypto -lmysqlclient -lm -lssl"

CONFIGURE_OPTS="\
    --with-modules=gmysql \
    --with-dynmodules=pipe \
    --localstatedir=/var/run \
    --enable-shared \
    --with-mysql-includes=/usr/local/include/mysql \
    --with-mysql-lib=/usr/local/lib \
    --with-boost=/include"

add_smf_support() {
  logmsg "Installing SMF"
  logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
  logcmd cp $SRCDIR/files/powerdns.xml \
      $DESTDIR/lib/svc/manifest/network/powerdns.xml
  logcmd mkdir -p $DESTDIR/lib/svc/method
  logcmd cp $SRCDIR/files/powerdns.svc \
      $DESTDIR/lib/svc/method/powerdns
}

init
download_source $PROG pdns $VER
patch_source
prep_build
build
add_smf_support
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: