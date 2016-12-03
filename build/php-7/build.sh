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

# http://de1.php.net/get/php-5.6.17.tar.gz/from/this/mirror
PROG=php
VER=7.0.13
PKG=runtime/php7
SUMMARY="PHP Server 7"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

BUILD_DEPENDS_IPS="compress/bzip2
    custom/database/sqlite3
    database/bdb
    library/libtool/libltdl
    library/libxml2
    library/libxslt
    system/library/iconv/unicode
    system/library/iconv/utf-8
    system/library/iconv/utf-8/manual
    system/library/iconv/xsh4/latin
    local/web/curl
    local/library/zlib
    library/libldap
    library/freetype2
    library/libgd
    library/libjpeg
    library/libmcrypt
    library/libpng
    library/libssh2
    library/libtiff
    library/security/cyrus-sasl
    library/mhash
    library/libmysqlclient18"

# Though not strictly needed since we override build(), still nice to set
BUILDARCH=64
PREFIX=$PREFIX/php7
reset_configure_opts

CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include/$ISAPART64/curl -I/usr/local/include -I /usr/local/include/mysql"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 -L$PREFIX/lib -R$PREFIX/lib"

CONFIGURE_OPTS_32=""
CONFIGURE_OPTS_64=""
CONFIGURE_OPTS="
        --prefix=$PREFIX
        --with-libdir=lib/$ISAPART64
        --sysconfdir=$PREFIX/etc
        --with-config-file-path=$PREFIX/etc
        --with-config-file-scan-dir=$PREFIX/etc/conf.d
        --includedir=$PREFIX/include
        --bindir=$PREFIX/bin
        --sbindir=$PREFIX/sbin
        --libdir=$PREFIX/lib
        --libexecdir=$PREFIX/libexec
        --datarootdir=$PREFIX/share
        --mandir=$PREFIX/man
        --enable-dtrace
        --enable-fpm
        --enable-xml
        --enable-pcntl
        --enable-sockets
        --enable-simplexml
        --enable-zip=shared
        --enable-gd-native-ttf
        --enable-exif=shared
        --enable-bcmath=shared
        --enable-calendar=shared
        --enable-ftp=shared
        --enable-mbstring=shared
        --enable-soap=shared
        --enable-pdo=shared
        --enable-mbstring=shared
        --with-pear=$PREFIX/pear
        --with-pdo-sqlite=shared
        --with-mysql=shared,mysqlnd
        --with-mysqli=shared,mysqlnd
        --with-zlib=shared
        --with-zlib-dir=/usr/local
        --with-sqlite3=shared
        --with-mhash=shared
        --with-mcrypt=shared
        --with-gd=shared
        --with-jpeg-dir=shared
        --with-png-dir=shared
        --with-tiff-dir=shared
        --with-freetype-dir=shared
        --with-curl=shared
        --with-openssl
        --with-gettext
        --with-iconv
        --with-ldap=shared,/usr/local
        --disable-cgi"

create_configure() {
  logmsg "Create configure file in $TMPDIR/$BUILDDIR"
  pushd $TMPDIR/$BUILDDIR >/dev/null
  logcmd /usr/bin/autoconf
  popd >/dev/null
}

make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} INSTALL_ROOT=${DESTDIR} install || \
        logerr "--- Make install failed"
    logmsg "--- copy php.ini examples"
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-production $DESTDIR/$PREFIX/etc/php.ini-production
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-development $DESTDIR/$PREFIX/etc/php.ini-development
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
create_configure
build

# Vim hints
# vim:ts=4:sw=4:et: