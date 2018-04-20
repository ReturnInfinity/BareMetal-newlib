#!/bin/bash

set -e

ver="2.5.0"

if [ ! -e "newlib-$ver.tar.gz" ]; then
	echo Downloading newlib
	wget ftp://sourceware.org/pub/newlib/newlib-$ver.tar.gz
fi

if [ ! -e "newlib-$ver" ]; then
	echo "Extracting newlib"
	tar xf newlib-$ver.tar.gz
fi

mkdir -p build

echo Configuring newlib

cp patches/config.sub.patch newlib-$ver/
cp patches/configure.host.patch newlib-$ver/newlib/
cp patches/configure.in.patch newlib-$ver/newlib/libc/sys/
cd newlib-$ver
patch < config.sub.patch
cd newlib
patch < configure.host.patch
cd libc/sys
patch < configure.in.patch
cd ../../../..

mkdir -p newlib-$ver/newlib/libc/sys/baremetal
cp patches/baremetal/* newlib-$ver/newlib/libc/sys/baremetal/

cd newlib-$ver/newlib/libc/sys
autoconf
cd baremetal
autoreconf
cd ../../../../../build

CFLAGS_FOR_TARGET="${CFLAGS_FOR_TARGET} -mno-red-zone -mcmodel=large"
CFLAGS_FOR_TARGET="${CFLAGS_FOR_TARGET} -fomit-frame-pointer -fno-stack-protector"
CFLAGS_FOR_TARGET="${CFLAGS_FOR_TARGET} -g"
export CFLAGS_FOR_TARGET

../newlib-$ver/configure --target=x86_64-pc-baremetal --disable-multilib

sed -i 's/TARGET=x86_64-pc-baremetal-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-baremetal-/WRAPPER) /g' Makefile

cd ..

./build.sh

./build-test-app.sh
