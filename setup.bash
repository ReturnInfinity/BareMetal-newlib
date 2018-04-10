#!/bin/bash

set -e
set -u

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

export CFLAGS_FOR_TARGET="-mno-red-zone -fomit-frame-pointer -fno-stack-protector -mcmodel=large"

../newlib-$ver/configure --target=x86_64-pc-baremetal --disable-multilib

sed -i 's/TARGET=x86_64-pc-baremetal-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-baremetal-/WRAPPER) /g' Makefile

cd ..

echo $PWD
./build.bash

./build-test-app.bash
