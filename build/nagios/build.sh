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

# https://www.nagios.org/downloads/nagios-core/thanks/?t=1487216873
# https://assets.nagios.com/downloads/nagioscore/releases/nagios-3.5.1.tar.gz
# https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz
# https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.4.tar.gz
PROG=nagios
VER=3.5.1
VERHUMAN=$VER
PKG=monitoring/nagios
SUMMARY="An Open Source system and network monitoring application"
DESC="$SUMMARY"

PREFIX=/usr/local/nagios
reset_configure_opts

# Path to perl to use for the embedded perl support
# PERLPATH32=/opt/OMNIperl/bin/$ISAPART
# PERLPATH64=/opt/OMNIperl/bin/$ISAPART64

BUILD_DEPENDS_IPS="monitoring/nagios/nagios-plugins \
                   library/libgd \
                   library/libjpeg \
                   library/libpng \
                   runtime/perl"

#                    pkg:/omniti/incorporation/perl-516-incorporation \

DEPENDS_IPS="custom/server/apache22 ${BUILD_DEPENDS_IPS}"

# Don't make a stub for p1.pl
NOSCRIPTSTUB=1

BUILDARCH=32

CPPFLAGS="-I/usr/local/include"
LDFLAGS32="$LDFLAGS32 -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"

USER=`/usr/bin/whoami`

CONFIGURE_OPTS="
    --with-nagios-user=${USER}
    --with-nagios-group=${USER}
    --with-httpd-conf=$PREFIX/etc
    --with-htmurl=
    --with-cgiurl=/nagios/cgi-bin
    --with-gd-inc=/usr/local/include
    --enable-embedded-perl
    --with-perlcache"

CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32
    --with-gd-lib=/usr/local/lib"
CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --with-gd-lib=/usr/local/lib/$ISAPART64"

add_configuration() {
  logcmd mkdir -p $DESTDIR/var/nagios
  logcmd mkdir -p $DESTDIR/var/nagios/spool/checkresults
  logcmd mkdir -p $DESTDIR/var/nagios/rw/
  logcmd mkdir -p $DESTDIR/etc/nagios/objects
  logcmd cp $SRCDIR/files/nagios.cfg \
      $DESTDIR/etc/nagios/nagios.cfg
  logcmd cp $SRCDIR/files/cgi.cfg \
      $DESTDIR/etc/nagios/cgi.cfg
  logcmd cp $SRCDIR/files/commands.cfg \
      $DESTDIR/etc/nagios/objects/commands.cfg
  logcmd cp $SRCDIR/files/templates.cfg \
      $DESTDIR/etc/nagios/objects/templates.cfg
  logcmd cp $SRCDIR/files/timeperiods.cfg \
      $DESTDIR/etc/nagios/objects/timeperiods.cfg
  logcmd cp $SRCDIR/files/contacts.cfg \
      $DESTDIR/etc/nagios/objects/contacts.cfg
  logcmd cp $SRCDIR/files/resource.cfg \
      $DESTDIR/etc/nagios/resource.cfg
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/modules/i386
  logcmd cp $SRCDIR/files/nagios.load \
      $DESTDIR/usr/local/apache22/conf/modules/i386/nagios.load
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/modules/amd64
  logcmd cp $SRCDIR/files/nagios-amd64.load \
      $DESTDIR/usr/local/apache22/conf/modules/amd64/nagios.load
  logcmd mkdir -p $DESTDIR/usr/local/apache22/conf/conf.d
  logcmd cp $SRCDIR/files/httpd-nagios.conf \
      $DESTDIR/usr/local/apache22/conf/conf.d/httpd-nagios.conf
  logcmd cp $SRCDIR/files/htpasswd.users \
      $DESTDIR/etc/nagios/htpasswd.users
  # logcmd cp $SRCDIR/files/config.inc.php \
  #     $DESTDIR/usr/local/nagios/share/config.inc.php
  # logcmd ln -s /etc/nagios $DESTDIR/usr/local/nagios/etc
}

smf_support() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/application/management
    logcmd cp $SRCDIR/files/manifest-nagios.xml \
        $DESTDIR/lib/svc/manifest/application/management/nagios.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/svc-nagios \
        $DESTDIR/lib/svc/method/svc-nagios
}

make_prog() {
    logmsg "--- make"
    logmsg "------ make all"
    logcmd $MAKE all ||
        logerr "------ make all failed"
}

build() {
    ORIGPATH=$PATH
    if [[ $BUILDARCH == "32" || $BUILDARCH == "both" ]]; then
        export PATH=$PERLPATH32:$ORIGPATH
        build32
    fi
    if [[ $BUILDARCH == "64" || $BUILDARCH == "both" ]]; then
        export PATH=$PERLPATH64:$ORIGPATH
        build64
    fi
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_configuration
smf_support
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: