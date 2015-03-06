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

PROG=nrpe
VER=2.15
VERHUMAN=$VER
PKG=monitoring/nagios/nrpe
SUMMARY="NRPE executes Nagios plugins remotely"
DESC="NRPE allows you to remotely execute Nagios plugins on other Linux/Unix machines. This allows you to monitor remote machine metrics (disk usage, CPU load, etc.). NRPE can also communicate with some of the Windows agent addons, so you can execute scripts and check metrics on remote Windows machines as well."

USER=`/usr/bin/whoami`

DEPENDS_IPS="monitoring/nagios/nagios-plugins"

CONFIGURE_OPTS="--enable-ssl \
    --with-nrpe-user=${USER} \
    --with-nrpe-group=${USER} \
    --with-nagios-user=${USER} \
    --with-nagios-group=${USER} \
    --enable-command-args" 

# command args may be evil! It is your turn to use it or not.

copy_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-nrpe.xml \
        $DESTDIR/lib/svc/manifest/network/nrpe.xml
    # create svc exec
    logcmd mkdir -p $DESTDIR/lib/svc/method/
    logcmd cp $SRCDIR/files/svc-nrpe \
        $DESTDIR/lib/svc/method/svc-nrpe
    # create config
    logcmd mkdir -p $DESTDIR/usr/local/etc
    logcmd cp $SRCDIR/files/nrpe.cfg \
        $DESTDIR/usr/local/etc/nrpe.cfg
    # fix isa-stub
    logcmd mkdir -p $DESTDIR/usr/local/libexec/i386
    logcmd cp $DESTDIR/usr/local/libexec/check_nrpe \
        $DESTDIR/usr/local/libexec/i386/check_nrpe
    # fix permissions
    logcmd chmod 0755 $DESTDIR/usr/local/bin/amd64
    logcmd chmod 0755 $DESTDIR/usr/local/bin/i386
    logcmd chmod 0755 $DESTDIR/usr/local/libexec
    logcmd chmod 0755 $DESTDIR/usr/local/libexec/amd64
    logcmd chmod 0755 $DESTDIR/usr/local/libexec/i386
}

init
download_source nagios $PROG $VER
patch_source
prep_build
build
make_isa_stub
copy_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
