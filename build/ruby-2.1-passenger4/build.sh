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
. ../../lib/gem-functions.sh

PROG=passenger
VER=4.0.59
VERHUMAN=$VER
PKG=runtime/ruby-2.1/passenger4
SUMMARY="Gem install of the passenger gem"
DESC="$SUMMARY"

DEPENDS_IPS="custom/server/apache22
             local/web/curl
             custom/library/apr"

RUBY_VER=2.1
GEM_DEPENDS=""

compile_apache22_module() {
  logmsg "Compiling apache22 module"
  RUBY_VER_EXTENDED="${RUBY_VER}.0"
  RUBY_HOME=${PREFIX}/ruby/${RUBY_VER}
  GEM_HOME=${DESTDIR}${RUBY_HOME}/lib/ruby/gems/${RUBY_VER_EXTENDED}
  ln -nfs /usr/local/apache22/bin/i386/apxs /usr/bin/apxs
  export APR_CONFIG=/usr/local/bin/apr-1-config
  export APXS2=/usr/local/apache22/bin/i386/apxs
  export LD_LIBRARY_PATH=/usr/local/lib
  export LANG=en_US.UTF-8
  export GEM_HOME="${GEM_HOME}"
  export GEM_PATH="${GEM_HOME}:${RUBY_HOME}/lib/ruby/gems/2.1.0/"
  logcmd ${DESTDIR}${RUBY_HOME}/bin/passenger-install-apache2-module -a --languages ruby
}

init
download_source
patch_source
prep_build
build
compile_apache22_module
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
