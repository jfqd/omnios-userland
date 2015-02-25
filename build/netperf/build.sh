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

# ftp://ftp.netperf.org/netperf/netperf-2.6.0.tar.gz
PROG=netperf
VER=2.6.0
VERHUMAN=$VER
PKG=network/netperf
SUMMARY="netperf is a TCP/UDP/sockets/etc performance benchmark"
DESC="Netperf is a benchmark that can be used to measure the performance of many different types of networking. \
It provides tests for both unidirecitonal throughput, and end-to-end latency. \
The environments currently measureable by netperf include:\
\
TCP and UDP via BSD Sockets for both IPv4 and IPv6\
DLPI\
Unix Domain Sockets\
SCTP for both IPv4 and IPv6"

CFLAGS="-lsocket -lnsl -lkstat $CFLAGS"

CFLAGS="-lxnet -lsocket -lnsl -lkstat -D_XOPEN_SOURCE=500 -D__EXTENSIONS__ $CFLAGS"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: