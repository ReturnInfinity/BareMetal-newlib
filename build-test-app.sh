#!/bin/bash

set -e

ver="2.5.0"

echo Compiling test application...

CC=gcc
LD=ld
OBJCOPY=objcopy

CFLAGS="${CFLAGS} -I newlib-$ver/newlib/libc/include"
CFLAGS="${CFLAGS} -fomit-frame-pointer -fno-stack-protector"
CFLAGS="${CFLAGS} -mno-red-zone"
CFLAGS="${CFLAGS} -mcmodel=large"
CFLAGS="${CFLAGS} -g"

LDFLAGS="${LDFLAGS} -T app.ld"
LDFLAGS="${LDFLAGS} -z max-page-size=0x1000"

$CC $CFLAGS -c test.c -o test.o
$LD $LDFLAGS -o test crt0.o test.o libc.a
$OBJCOPY -O binary test test.app

echo Complete!
