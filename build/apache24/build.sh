#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=httpd
VER=2.4.23
PKG=custom/server/apache24
SUMMARY="$PROG - Apache Web Server ($VER)"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="custom/database/sqlite3 \
    library/security/openssl \
    custom/library/apr \
    custom/library/apr-util"

DEPENDS_IPS="$BUILD_DEPENDS_IPS"

PREFIX=/usr/local/apache24
reset_configure_opts

# Package info
NAME=Apache
CATEGORY=network

BUILDARCH=64

# Define some architecture specific variables
if [[ $ISAPART == "i386" ]]; then
    LAYOUT64=SolAmd64
    #DEF64="-DALTLAYOUT -DAMD64"
else
    # sparc
    LAYOUT64=SolSparc64
    #DEF64="-DALTLAYOUT -DSPARCV9"
fi

# General configure options - BASE is for options to be applied everywhere
# and the *64 variables are for 64 bit builds.
CONFIGURE_OPTS_BASE="--with-mpm=prefork
    --enable-mpms-shared=all
    --enable-mods-shared=reallyall"

CONFIGURE_OPTS_64="$CONFIGURE_OPTS_BASE
    --enable-layout=$LAYOUT64
    --with-apr=/usr/local/bin/$ISAPART64/apr-1-config
    --with-apr-util=/usr/local/bin/$ISAPART64/apu-1-config"

LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"
CFLAGS64="$CFLAGS64 -I/usr/local/include -g"

# Extra script/file installs
add_file() {
    logcmd cp $SRCDIR/files/$1 $DESTDIR$PREFIX/$2
    # logcmd chown root:root $DESTDIR$PREFIX/$2
    if [[ -n "$3" ]]; then
        logcmd chmod $3 $DESTDIR$PREFIX/$2
    else
        logcmd chmod 0444 $DESTDIR$PREFIX/$2
    fi
}

# Extra script/file installs
add_extra_files() {
    logmsg "Installing custom files and scripts"
    logcmd rm -f $DESTDIR$PREFIX/conf/httpd.conf
    add_file httpd.conf conf/httpd.conf
    logcmd mkdir -p $DESTDIR$PREFIX/conf/conf.d
    logcmd mkdir -p $DESTDIR$PREFIX/conf/modules
    logcmd mkdir -p $DESTDIR$PREFIX/conf/sites-enabled
    logcmd mkdir -p $DESTDIR$PREFIX/conf/sites-available
    add_file ports.conf conf/conf.d/ports.conf
    add_file modules.load conf/modules/modules.load
    logcmd mkdir -p $DESTDIR$PREFIX/var/log
    logcmd touch $DESTDIR$PREFIX/var/log/error.log
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-httpd-apache.xml \
              $DESTDIR/lib/svc/manifest/network/httpd-24.xml
}

# Add some more files once the source code has been downloaded
save_function download_source download_source_orig
download_source() {
    download_source_orig "$@"
    logcmd cp $SRCDIR/files/config.layout $TMPDIR/$BUILDDIR/
}

# Add another step after patching the source (a new file needs to be made
# executable
save_function patch_source patch_source_orig
patch_source() {
    patch_source_orig
    logcmd chmod +x $TMPDIR/$BUILDDIR/libtool-dep-extract
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_extra_files
make_package
clean_up
