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

PROG=dovecot
VER=2.2.29.1
VERHUMAN=$VER
PKG=service/network/imap/dovecot
SUMMARY="Dovecot is an open source IMAP and POP3 email server."
DESC="$SUMMARY ($VER)"

BUILDARCH=64
BUILD_DEPENDS_IPS="library/libwrap"

DEPENDS_IPS="system/library/gcc-4-runtime
             database/bdb
             library/libmysqlclient18
             library/security/cyrus-sasl
             library/libwrap"

CPPFLAGS="-I/usr/local/include -I/usr/local/include/mysql"
LDFLAGS="-L/usr/local/lib -R/usr/local/lib"

AR=gar

# MYSQL_INCLUDE="-I/usr/local/include/mysql"
# MYSQL_LIBS="-L/usr/local/lib/amd64 -R/usr/local/lib/amd64 -lmysqlclient -lsocket -lnsl -lm -lssl -lcrypto"

CONFIGURE_OPTS="--sysconfdir=/etc
    --localstatedir=/var
    --mandir=$PREFIX/man
    --enable-static=no
    --with-gssapi=no
    --with-ldap=no
    --with-sql=plugin
    --with-mysql
    --with-zlib
    --with-bzlib
    --with-libwrap
    --with-ssl=openssl
    "
# if used in chroot add the following option:
# --with-ioloop=poll

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-dovecot.xml \
        $DESTDIR/lib/svc/manifest/network/dovecot.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/dovecot \
        $DESTDIR/lib/svc/method/dovecot
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: