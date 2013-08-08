#! /bin/sh
aclocal -I m4
autoconf
libtoolize --force || glibtoolize --force
automake --add-missing
