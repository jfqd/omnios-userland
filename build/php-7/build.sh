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
VER=7.0.4
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
PREFIX=$PREFIX/php56
reset_configure_opts

#CFLAGS="-O2 -DZLIB_INTERNAL=1 -std=c99"
CFLAGS="-O2 -DZLIB_INTERNAL=1 -std=gnu99"
CPPFLAGS="-I/usr/local/include"
LDFLAGS="-L/usr/local/lib -R/usr/local/lib \
    -L$PREFIX/lib -R$PREFIX/lib"

CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include/$ISAPART64/curl \
    -I/usr/local/include -I /usr/local/include/mysql"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 \
    -L$PREFIX/lib -R$PREFIX/lib"

# https://www.mail-archive.com/php-install@lists.php.net/msg16137.html
export PHP_MYSQLND_ENABLED=yes

export EXTENSION_DIR=$PREFIX/lib/modules
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
        --with-pear=$PREFIX/pear
        --enable-dtrace
        --enable-fpm
        --enable-xml
        --enable-simplexml
        --enable-zip=shared
        --with-zlib=shared
        --with-zlib-dir=/usr/local
        --with-sqlite3=shared
        --enable-pdo=shared
        --with-pdo-sqlite=shared
        --with-mysql=shared,mysqlnd
        --with-mysqli=shared,mysqlnd
        --with-pdo-mysql=shared,mysqlnd
        --enable-mbstring=shared
        --with-mhash=shared
        --with-mcrypt=shared
        --with-gd=shared
        --with-jpeg-dir=shared
        --with-png-dir=shared
        --with-tiff-dir=shared
        --with-freetype-dir=shared
        --enable-gd-native-ttf
        --enable-exif=shared
        --enable-bcmath=shared
        --enable-calendar=shared
        --enable-ftp=shared
        --enable-mbstring=shared
        --enable-soap=shared
        --with-curl=shared
        --with-openssl
        --enable-pcntl
        --with-gettext
        --with-iconv
        --enable-sockets
        --with-ldap=shared,/usr/local"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build

# Vim hints
# vim:ts=4:sw=4:et: