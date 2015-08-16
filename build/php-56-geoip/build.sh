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

PROG=geoip
VER=1.0.8
VERHUMAN=$VER
PKG=runtime/php56/php-geoip
SUMMARY="This PHP extension allows you to find the location of an IP address"
DESC="This PHP extension allows you to find the location of an IP address - City, State, Country, Longitude, Latitude, and other information as all, such as ISP and connection type. For more info, please visit Maxmind's website."

DEPENDS_IPS="runtime/php56 library/geoip developer/re2c"

BUILDARCH=64
PREFIX=$PREFIX/php56
reset_configure_opts

CONFIGURE_OPTS="--with-php-config=$PREFIX/bin/php-config --with-geoip"

CPPFLAGS="-I/usr/local/include"
LDFLAGS="-L/usr/local/lib -R/usr/local/lib \
    -L$PREFIX/lib -R$PREFIX/lib"

CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 \
    -L$PREFIX/lib -R$PREFIX/lib"

make_install64() {
  logmsg "--- make install"
  logcmd mkdir -p $DESTDIR/$PREFIX/lib/modules
  logcmd cp $TMPDIR/$BUILDDIR/modules/geoip.so $DESTDIR/$PREFIX/lib/modules
  logcmd cp $TMPDIR/$BUILDDIR/modules/geoip.la $DESTDIR/$PREFIX/lib/modules
}

create_configure() {
  logmsg "Create configure file in $TMPDIR/$BUILDDIR"
  pushd $TMPDIR/$BUILDDIR >/dev/null
  logcmd /usr/local/php56/bin/phpize
  logcmd /usr/bin/aclocal && /usr/bin/libtoolize --force && /usr/sfw/bin/autoreconf
  popd >/dev/null
}

init
download_source php-$PROG $PROG $VER
patch_source
prep_build
create_configure
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: