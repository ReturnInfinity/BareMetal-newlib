#!/bin/bash

set -e
set -u

ver="2.5.0"

echo Compiling test application...

gcc -I newlib-$ver/newlib/libc/include/ -c test.c -o test.o
ld -T app.ld -o test crt0.o test.o libc.a
objcopy -O binary test test.app

echo Complete!
