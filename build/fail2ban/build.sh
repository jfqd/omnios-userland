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

# https://github.com/fail2ban/fail2ban/archive/0.9.3.tar.gz
PROG=fail2ban   # App name
VER=0.9.3       # App version
VERHUMAN=$VER   # Human-readable version
PKG=network/fail2ban   # Package name (e.g. library/foo)
SUMMARY="Ban IPs that make too many password failures"
DESC="Fail2ban scans log files like /var/log/pwdfail or \
/var/log/apache/error_log and bans IP that makes too many password \
failures. It updates firewall rules to reject the IP address."

BUILD_DEPENDS_IPS="runtime/python-26 archiver/gnu-tar"
DEPENDS_IPS="runtime/python-26"

LDFLAGS64="-L$PYTHONLIB -R$PYTHONLIB -L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"

# omniti-ms python is 64-bit only
# BUILDARCH=64
PYTHON=/usr/bin/python

TAR=/usr/gnu/bin/tar

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/fail2ban.xml \
        $DESTDIR/lib/svc/manifest/network/fail2ban.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/fail2ban.svc \
        $DESTDIR/lib/svc/method/fail2ban
    logmsg "Installing extra config"
    logcmd cp $SRCDIR/files/paths-omnios.conf \
        $DESTDIR/etc/fail2ban/paths-omnios.conf
    logcmd sed -i -e "s#paths-debian.conf#paths-omnios.conf#g" $DESTDIR/etc/fail2ban/jail.conf
    logcmd cp $SRCDIR/files/ipfilter.conf \
        $DESTDIR/etc/fail2ban/action.d/ipfilter.conf
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: