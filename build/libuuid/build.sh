#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=libuuid
VER=1.0.3
PKG=custom/library/uuid
SUMMARY="libuuid ($PROG)"
DESC="$SUMMARY"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up
