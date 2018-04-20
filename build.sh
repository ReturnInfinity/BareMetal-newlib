#!/bin/bash

set -e
set -u

ver="2.5.0"

echo Building Newlib

cd build

make

echo Build complete!

cd x86_64-pc-baremetal/newlib/
cp libc.a ../../..
cp crt0.o ../../..
cd ../../..
