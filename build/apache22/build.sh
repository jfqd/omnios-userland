#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=httpd
VER=2.2.29
PKG=custom/server/apache22
SUMMARY="$PROG - Apache Web Server ($VER)"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="custom/database/sqlite3 \
    library/security/openssl \
    custom/library/apr \
    custom/library/apr-util"

DEPENDS_IPS="custom/library/apr \
    custom/library/apr-util \
    library/security/openssl \
    custom/database/sqlite3"

PREFIX=/usr/local/apache22
reset_configure_opts

# Package info
NAME=Apache
CATEGORY=network

BUILDARCH=64
MIRROR=archive.apache.org
DIR=dist/httpd # Mirror directory to download from
MPMS="worker event prefork" # Which MPMs to build

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
CONFIGURE_OPTS_BASE="--enable-dtrace
    --enable-ldap
    --enable-authnz-ldap
    --enable-ssl
    --with-ssl=/opt/omni
    --enable-file-cache
    --enable-proxy
    --enable-proxy-http
    --enable-cache
    --enable-disk-cache
    --enable-mem-cache
    --enable-modules=all
    --disable-reqtimeout
    --disable-proxy-scgi"

CONFIGURE_OPTS_64="
    --enable-layout=$LAYOUT64
    --with-apr=/usr/local/bin/$ISAPART64/apr-1-config
    --with-apr-util=/usr/local/bin/$ISAPART64/apu-1-config"

LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"
CFLAGS64="$CFLAGS64 -g"

# Run a build for each MPM
# This function is provided with a callback parameter - this should be the
# name of the function to call to actually do the building
build_mpm() {
    CALLBACK=$1
    for MPM in $MPMS; do
        logmsg "Building $MPM MPM"
        if [[ "$MPM" != "prefork" ]]; then
            CONFIGURE_OPTS="$CONFIGURE_OPTS_BASE
                --with-program-name=httpd.$MPM
                --with-mpm=$MPM"
        else
            # prefork doesn't need any special options
            CONFIGURE_OPTS="$CONFIGURE_OPTS_BASE"
        fi
        # run the callback function
        $CALLBACK
    done
}

# Redefine the build64 to build all MPMs
save_function build64 build64_orig

build64() {
    logcmd perl -pi -e "
    s#-L/usr/local/lib#-L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64#g;
    s#(-[LR]/usr/local/lib(?!/))#"'$1'"/$ISAPART64#g;
    s#^EXTRA_LDFLAGS = .+#EXTRA_LDFLAGS = #;
    " $TMPDIR/$BUILDDIR/build/config_vars.mk
    build_mpm build64_orig
}

# Extra script/file installs
add_file() {
    logcmd cp $SRCDIR/files/$1 $DESTDIR$PREFIX/$2
    logcmd chown root:root $DESTDIR$PREFIX/$2
    if [[ -n "$3" ]]; then
        logcmd chmod $3 $DESTDIR$PREFIX/$2
    else
        logcmd chmod 0444 $DESTDIR$PREFIX/$2
    fi
}

add_extra_files() {
    logmsg "Installing custom files and scripts"
    add_file manifest-http-apache.xml conf/http-apache.xml
    logcmd rm -f $DESTDIR$PREFIX/conf/httpd.*.conf
    logcmd mv $DESTDIR$PREFIX/conf/httpd.conf $DESTDIR$PREFIX/conf/httpd.conf.dist
    add_file httpd.conf conf/httpd.conf
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
download_source $DIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_extra_files
make_package
clean_up
