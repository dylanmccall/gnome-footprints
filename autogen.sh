#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

OLDDIR=`pwd`
cd $srcdir

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
    echo "*** No autoreconf found, please install it ***"
    exit 1
fi

INTLTOOLIZE=`which intltoolize`
if test -z $INTLTOOLIZE; then
    echo "*** No intltoolize found, please install the intltool package ***"
    exit 1
fi

# git submodule update --init --recursive
# We don't use git, yet, so we're going to pretend to have a git submodule for libgd
if test ! -d libgd; then
	git clone git://git.gnome.org/libgd
else
	(cd libgd && git pull)
fi

autopoint --force || exit $?
AUTOPOINT='intltoolize --automake --copy' autoreconf --force --install --verbose

cd $OLDDIR
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"