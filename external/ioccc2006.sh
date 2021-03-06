#!/bin/sh
set -e

. "$(dirname "$0")/utils.sh"

TOPDIR="$(pwd)"
grab "http://www.ioccc.org/2006/2006.tar.gz" 1f51afe784afa8a4e1d5d8e8daf091c6

cd "$BUILDDIR"
rm -rf ioccc2006
tar -xf "$PACKAGEDIR/2006.tar.gz"
mv 2006 ioccc2006
cd ioccc2006
patch -p0 < "$TOPDIR/ioccc2006.patch"
patch -p0 < "$TOPDIR/ioccc2006_sloane.patch"
CC="cparser -m32" make

cd "$TOPDIR/ioccc2006_tests"
./testit.sh
