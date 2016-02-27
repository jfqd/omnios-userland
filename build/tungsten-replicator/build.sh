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

# https://github.com/vmware/tungsten-replicator
# http://pubs.vmware.com/continuent/continuent-replicator-5.0/index.html
PROG=tungsten-replicator
VER=5.0.0
VERHUMAN=$VER
PKG=database/tungsten-replicator
SUMMARY="Tungsten Replicator is an open source replication engine supporting a variety of different extractor and applier modules."
DESC="Tungsten Replicator is an open source replication engine supporting a variety of different extractor and applier modules. Data can be extracted from MySQL, Oracle and Amazon RDS, and applied to transactional stores, including MySQL, Oracle, and Amazon RDS; NoSQL stores such as MongoDB, and datawarehouse stores such as Vertica, Hadoop, and Amazon rDS."

BUILD_DEPENDS_IPS="runtime/ruby-2.1"
DEPENDS_IPS="runtime/ruby-2.1
             network/rsync"

export JAVA_HOME=/opt/java/jdk
export ANT_HOME=/opt/java/ant

build() {
  pushd ${TMPDIR}/${BUILDDIR}/builder >/dev/null
  export PATH=$ANT_HOME/bin:$JAVA_HOME/bin/amd64:$PATH
  logcmd ./build.sh
  logcmd mkdir -p ${DESTDIR}/opt
  logcmd mv build/tungsten-replicator-${VER} ${DESTDIR}/opt/tungsten-replicator-${VER}
  logcmd cp extra/tools/accept_release_notes ${DESTDIR}/opt/tungsten-replicator-${VER}/tools/accept_release_notes
  logcmd cp $SRCDIR/files/solaris.rb ${DESTDIR}/opt/tungsten-replicator-${VER}/cluster-home/lib/ruby/ipparse/platforms/solaris.rb
  logcmd cp $SRCDIR/files/validation_deployment.rb ${DESTDIR}/opt/tungsten-replicator-${VER}/tools/ruby-tpm/configure/modules/validation_deployment.rb
  logcmd touch ${DESTDIR}/opt/tungsten-replicator-${VER}/RELEASE_NOTES
  cd ${DESTDIR}/opt
  logcmd ln -nfs tungsten-replicator-5.0.0 tungsten-replicator
  popd >/dev/null
}

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
