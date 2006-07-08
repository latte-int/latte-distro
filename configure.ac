#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(latte-corretto, 1.2-mk-0.5)
AM_INIT_AUTOMAKE(foreign)
AM_MAINTAINER_MODE
AC_CONFIG_FILES([Makefile])

# For Solaris/SPARC, we need to request ABI=32 for GMP builds
# because it will build a 64-bit library instead.
AC_CANONICAL_TARGET
case ${target_cpu} in
sparc) 
       gmp_configure_options="ABI=32"
       ;;
esac
AC_SUBST(GMP_CONFIGURE_OPTIONS, ${gmp_configure_options})

AC_PROG_CC
AC_PROG_CXX
AC_CHECK_PROGS(TAR, [gtar tar])
#AC_PROG_INSTALL

AC_LANG(C)
AX_COMPILER_VENDOR
AX_CC_MAXOPT

AC_LANG(C++)
AX_COMPILER_VENDOR
AX_CXX_MAXOPT

enable_LIDIA=yes
AC_ARG_ENABLE(LIDIA, AS_HELP_STRING([--disable-lidia],
				[Do not use the non-free library LiDIA.]))
AC_SUBST(ENABLE_LIDIA, ${enable_LIDIA})

AC_OUTPUT
