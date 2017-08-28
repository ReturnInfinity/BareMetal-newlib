# BareMetal-newlib

Introduction
------------

This repository contains the files, script, and instructions necessary to build the [newlib](http://sourceware.org/newlib/) C library for BareMetal OS. The latest version of Newlib as of this writing is 2.5.0

newlib gives BareMetal OS access to the standard set of C library calls like `printf()`, `scanf()`, `memcpy()`, etc.

These instructions are for executing on a 64-bit Linux host. Building on a 64-bit host saves us from the steps of building a cross compiler. The latest distribution of Ubuntu was used while writing this document.


Building Details
----------------

You will need the following Linux packages. Use your prefered packange manager to install them:

	autoconf libtool sed gawk bison flex m4 texinfo texi2html unzip make

Run the build script:

	./build-newlib.sh

After a lengthy compile you should have a libc.a and crt0.o in your directory

libc.a is the compiled C library that is ready for linking. crt0.o is the starting binary stub for your program.

By default libc.a will be about 6.8 MiB. You can `strip` it to make it a little more compact. `strip` can decrease it to about 1.4 MiB.

	strip --strip-debug libc.a

Compiling Your Application
--------------------------

By default GCC will look in predefined system paths for the C headers. This will not work correctly as we need to use the Newlib C headers. Using the `-I` argument we can point GCC where to find the correct headers. Adjust the path as necessary.

	gcc -I newlib-2.5.0/newlib/libc/include/ -c test.c -o test.o
	ld -T app.ld -o test.app crt0.o test.o libc.a
