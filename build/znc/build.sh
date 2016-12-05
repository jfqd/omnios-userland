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

PROG=znc
VER=1.6.3
VERHUMAN=$VER
PKG=service/network/znc
SUMMARY="Advanced IRC bouncer"
DESC="ZNC is an advanced IRC bouncer that is left connected so an IRC client can disconnect/reconnect without losing the chat session."

# service_configs() {
#     logmsg "Installing SMF"
#     logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
#     logcmd cp $SRCDIR/files/manifest-znc.xml \
#         $DESTDIR/lib/svc/manifest/network/znc.xml
# }

sample_config() {
    logmsg "Copying sample configuration file"
    logcmd mkdir -p $DESTDIR/var/lib/znc/
    # logcmd cp $SRCDIR/files/znc.config $DESTDIR/var/lib/znc/znc.sample
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
sample_config
# service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
