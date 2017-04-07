#!/bin/sh

echo Downloading newlib
wget ftp://sourceware.org/pub/newlib/newlib-2.5.0.tar.gz
tar xf newlib-2.5.0.tar.gz
rm newlib-2.5.0.tar.gz
mkdir build

echo Configuring newlib

cp patches/config.sub.patch newlib-2.5.0/
cp patches/configure.host.patch newlib-2.5.0/newlib/
cp patches/configure.in.patch newlib-2.5.0/newlib/libc/sys/
cd newlib-2.5.0
patch < config.sub.patch
cd newlib
patch < configure.host.patch
cd libc/sys
patch < configure.in.patch
cd ../../../..
pwd

mkdir newlib-2.5.0/newlib/libc/sys/baremetal
cp patches/baremetal/* newlib-2.5.0/newlib/libc/sys/baremetal/

cd newlib-2.5.0/newlib/libc/sys
autoconf
cd baremetal
autoreconf
cd ../../../../../build

../newlib-2.5.0/configure --target=x86_64-pc-baremetal --disable-multilib

sed -i 's/TARGET=x86_64-pc-baremetal-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-baremetal-/WRAPPER) /g' Makefile

echo Building Newlib

make

echo Build complete!

cd x86_64-pc-baremetal/newlib/
cp libc.a ../../..
cp libm.a ../../..
cp crt0.o ../../..
cd ../../../..

#echo Compiling test application...

#cp ../src/BareMetal-OS/newlib/*.* .

#gcc -I newlib-2.5.0/newlib/libc/include/ -c test.c -o test.o
#ld -T app.ld -o test.app crt0.o test.o libc.a

#cp ../src/BareMetal-OS/programs/libBareMetal.* .
#gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libBareMetal.o libBareMetal.c

#echo Complete!
