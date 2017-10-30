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
# Set Ruby version
RUBY_VER=2.2
# Load support functions
. ../../lib/functions.sh
. ../../lib/gem-functions.sh

PROG=passenger
VER=5.1.11
VERHUMAN=$VER
PKG=runtime/ruby-2.2/passenger5
SUMMARY="Gem install of the passenger gem"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="custom/server/apache24
             runtime/ruby-2.2
             local/web/curl
             custom/library/apr
             runtime/ruby-2.2/rack
             library/libssh2
             library/libldap
             library/security/cyrus-sasl
             developer/object-file"

DEPENDS_IPS="$BUILD_DEPENDS_IPS"

GEM_DEPENDS=""

# export CC=/opt/gcc-4.8.1/bin/gcc
# export CXX=/opt/gcc-4.8.1/bin/g++
# export CPP=/opt/gcc-4.8.1/bin/cpp

compile_apache24_module() {
  logmsg "Compiling apache24 module"
  RUBY_HOME=${PREFIX}/ruby/${RUBY_VER}
  pfexec ln -nfs ${PREFIX}/apache24/bin/amd64/apxs /usr/local/bin/apxs
  export LANG=en_US.UTF-8
  # export VERBOSE=1
  logcmd ${DESTDIR}${RUBY_HOME}/bin/passenger-install-apache2-module -a --languages ruby
  logmsg "Remove docs cause of pkgmogrify issue with spaces in filenames."
  GEM_HOME=${DESTDIR}${RUBY_HOME}/lib/ruby/gems/${RUBY_VER}.0
  logcmd rm -rf ${GEM_HOME}/gems/passenger-${VER}/doc
  logmsg "Cleanup rake and rack gems"
  logcmd rm -rf ${DESTDIR}${RUBY_HOME}/bin/rackup
  logcmd rm -rf ${DESTDIR}${RUBY_HOME}/bin/rake
  logcmd rm -rf ${GEM_HOME}/bin/rackup
  logcmd rm -rf ${GEM_HOME}/bin/rake
  logcmd rm -rf ${GEM_HOME}/cache/rack-*.gem
  logcmd rm -rf ${GEM_HOME}/cache/rake-*.gem
  logcmd rm -rf ${GEM_HOME}/gems/rack-*
  logcmd rm -rf ${GEM_HOME}/gems/rake-*
  logcmd rm -rf ${GEM_HOME}/specifications/rack-*
  logcmd rm -rf ${GEM_HOME}/specifications/rake-*
  logmsg "Copy config files"
  logcmd mkdir -p $DESTDIR/usr/local/apache24/conf/modules
  logcmd cp $SRCDIR/files/passenger.load $DESTDIR/usr/local/apache24/conf/modules
  logcmd sed -i -e "s#VERSION#${VER}#g" $DESTDIR/usr/local/apache24/conf/modules/passenger.load
  logcmd mkdir -p $DESTDIR/usr/local/apache24/conf/conf.d
  logcmd cp $SRCDIR/files/passenger.conf $DESTDIR/usr/local/apache24/conf/conf.d
  logcmd sed -i -e "s#VERSION#${VER}#g" $DESTDIR/usr/local/apache24/conf/conf.d/passenger.conf
}

init
download_source
patch_source
prep_build
build
compile_apache24_module
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: