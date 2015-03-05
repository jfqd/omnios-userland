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

PROG=mysql-proxy
VER=0.8.5
VERHUMAN=$VER
PKG=database/mysql-proxy
SUMMARY="MySQL proxy application"
DESC="The MySQL Proxy is an application that \
communicates over the network using the MySQL \
client/server protocol and provides communication \
between one or more MySQL servers and one or \
more MySQL clients."

BUILDARCH=64
BUILDDIR=mysql-proxy-${VER}-solaris11-x86-${BUILDARCH}bit

default_build() {
  logmsg "Move distribution into place"
  logcmd mkdir -p $DESTDIR/usr/local/
  logcmd mv $TMPDIR/$BUILDDIR $DESTDIR/usr/local/mysql-proxy \
      || logerr "cannot move distribution into place"
  
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/application/database
    logcmd cp $SRCDIR/files/manifest-mysql-proxy.xml \
        $DESTDIR/lib/svc/manifest/application/database/mysql-proxy.xml
}

default_config() {
    logmsg "Copying default configuration files"
    logcmd mkdir -p $DESTDIR/etc/mysql-proxy
    logcmd cp $SRCDIR/files/my.cnf $DESTDIR/etc/mysql-proxy/my.cnf
    logcmd touch $DESTDIR/var/log/mysql-proxy.log
    logcmd mkdir -p $DESTDIR/usr/local/mysql-proxy/lib/mysql-proxy/lua
    logcmd cp $SRCDIR/files/admin.lua \
        $DESTDIR/usr/local/mysql-proxy/lib/mysql-proxy/lua/
    logcmd mkdir -p $DESTDIR/usr/local/mysql-proxy/lib/mysql-proxy/lua/proxy
    logcmd cp $SRCDIR/files/rw-splitting.lua \
        $DESTDIR/usr/local/mysql-proxy/lib/mysql-proxy/lua/proxy
}

init
download_source $PROG $BUILDDIR
patch_source
prep_build
default_build
make_isa_stub
service_configs
default_config
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
