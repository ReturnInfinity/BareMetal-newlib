#!/bin/sh

ver="2.5.0"

echo Downloading newlib

wget ftp://sourceware.org/pub/newlib/newlib-$ver.tar.gz
tar xf newlib-$ver.tar.gz
rm newlib-$ver.tar.gz
mkdir build

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

mkdir newlib-$ver/newlib/libc/sys/baremetal
cp patches/baremetal/* newlib-$ver/newlib/libc/sys/baremetal/

cd newlib-$ver/newlib/libc/sys
autoconf
cd baremetal
autoreconf
cd ../../../../../build

../newlib-$ver/configure --target=x86_64-pc-baremetal --disable-multilib

sed -i 's/TARGET=x86_64-pc-baremetal-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-baremetal-/WRAPPER) /g' Makefile

echo Building Newlib

make

echo Build complete!

cd x86_64-pc-baremetal/newlib/
cp libc.a ../../..
cp crt0.o ../../..
cd ../../..

echo Compiling test application...

gcc -I newlib-$ver/newlib/libc/include/ -c test.c -o test.o
ld -T app.ld -o test.app crt0.o test.o libc.a

echo Complete!
