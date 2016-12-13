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

PROG=php
VER=5.6.28
PKG=custom/server/apache24/mod-php7
SUMMARY="PHP 7 - mod-php7 extension for Apache 2.4"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

DEPENDS_IPS="custom/server/apache24"

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

BUILDARCH=64
PREFIX=$PREFIX/php7
reset_configure_opts

CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include/$ISAPART64/curl -I/usr/local/include -I /usr/local/include/mysql -I$TMPDIR/$PROG-$VER/ext"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 -L$PREFIX/lib -R$PREFIX/lib"

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
        --with-openssl
        --enable-pcntl
        --with-gettext
        --with-iconv
        --enable-dtrace
        --enable-xml
        --enable-simplexml
        --with-apxs2=/usr/local/apache22/bin/amd64/apxs"

create_configure() {
  logmsg "Create configure file in $TMPDIR/$BUILDDIR"
  pushd $TMPDIR/$BUILDDIR >/dev/null
  logcmd /usr/bin/autoconf
  popd >/dev/null
}

# We need to make a fake httpd.conf so apxs in make install
make_httpd_conf() {
    logmsg "Generating fake httpd.conf file"
    logcmd mkdir -p $DESTDIR/usr/local/apache24/conf
    echo -e "\n\n\nLoadModule access_module modules/mod_access.so\n\n\n" > \
        $DESTDIR/usr/local/apache24/conf/httpd.conf
}

# And a function to remove the temporary httpd.conf files
remove_httpd_conf() {
    logmsg "Removing Generated httpd.conf file"
    logcmd rm -rf $DESTDIR/usr/local/apache24/conf/httpd.conf* ||
        logerr "Failed to remove apache24 config"
}

make_install() {
    logmsg "--- fix CGIDIR"
    logcmd sed -i -e 's#@CGIDIR@/$(program_prefix)php$(program_suffix)#/usr/local/php7/bin/php-cgi#g' $TMPDIR/$BUILDDIR/Makefile
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} INSTALL_ROOT=${DESTDIR} install || \
        logerr "--- Make install failed"
    logmsg "--- copy configuration"
    logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/modules
    logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/conf.d
    logcmd cp $SRCDIR/files/php7.load \
        $DESTDIR/usr/local/apache22/conf/modules/php7.load
    logcmd cp $SRCDIR/files/php7.conf \
        $DESTDIR/usr/local/apache22/conf/conf.d/php7.conf
}

# There are some dotfiles/dirs that look like noise
clean_dot_and_php_files() {
    logmsg "--- Cleaning up dotfiles in destination directory"
    logcmd rm -rf $DESTDIR/.??* || \
        logerr "--- Unable to clean up destination directory"
    logcmd rm -rf $DESTDIR/usr/local/php7 || \
        logerr "--- Unable to clean up php56 directory"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
create_configure
make_httpd_conf
build
remove_httpd_conf
clean_dot_and_php_files
make_package ext.mog
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
