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

# Adapted from ms branch build/chef/build.sh

if [ -z $RUBY_VER ]; then
  RUBY_VER=2.1
fi

BUILDARCH=32
DEPENDS_IPS="runtime/ruby-${RUBY_VER}"
BUILD_DEPENDS_IPS="gnu-coreutils"

RUBY_VER_EXTENDED="${RUBY_VER}.0"

RUBY_HOME="${PREFIX}/ruby/${RUBY_VER}"
GEM_BIN="${RUBY_HOME}/bin/gem"

# Place your ordered list of dependencies in this var

GEM_DEPENDS=""

# Optionally, provide a gemrc in your build dir/files/gemrc.

build32(){
    logmsg "Building"
    
    if [[ -e $SRCDIR/files/gemrc ]]; then
        GEMRC=$SRCDIR/files/gemrc
    else
        GEMRC=$MYDIR/gemrc
    fi

    pushd $TMPDIR/$BUILDDIR > /dev/null
    GEM_HOME=${DESTDIR}${RUBY_HOME}/lib/ruby/gems/${RUBY_VER_EXTENDED}
    export GEM_HOME
    RUBYLIB=${DESTDIR}${RUBY_HOME}:${DESTDIR}${RUBY_HOME}/lib/ruby/site_ruby/${RUBY_VER_EXTENDED}
    export RUBYLIB
    for i in $GEM_DEPENDS; do
      GEM=${i%-[0-9.]*}
      GVER=${i##[^0-9.]*-}
      logmsg "--- gem install $GEM-$GVER"
      logcmd $GEM_BIN --config-file $GEMRC install \
        -r --no-rdoc --no-ri -i ${GEM_HOME} -v $GVER $GEM $GEM_BUILD_OPTIONS || \
        logerr "Failed to install $GEM-$GVER"
    done
    logmsg "--- gem install $PROG-$VER"
    logcmd $GEM_BIN --config-file $GEMRC install \
         -r --no-rdoc --no-ri -i ${GEM_HOME} -v $VER $PROG || \
        logerr "Failed to gem install $PROG-$VER"
    # only process files if bin dir is not empty
    if [ "$(ls -A $GEM_HOME/bin)" ]; then
        logmsg "--- Fixing include paths on binaries"
        logcmd mkdir -p "${DESTDIR}/${RUBY_HOME}/bin"
        for i in $GEM_HOME/bin/*; do
            logmsg "----- Processing file: $i"
            sed -e "/require 'rubygems'/ a\\
Gem.use_paths(Gem.dir, [\"${RUBY_HOME}/lib/ruby/gems/${RUBY_VER_EXTENDED}\"])\\
Gem.refresh\\
" $i >$i.tmp
            mv $i.tmp $i
            chmod +x $i
            logmsg "--- Copy binary to regular bin path"
            logcmd cp $i "${DESTDIR}/${RUBY_HOME}/bin"
        done
    fi
}

download_source() {
    # Just make the temp build dir
    logcmd mkdir -p $TMPDIR/$PROG-$VER
}
