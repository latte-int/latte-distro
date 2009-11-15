#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(latte-for-tea-too, 1.4-prerelease-2009-11-14)
AM_INIT_AUTOMAKE(foreign)
AM_MAINTAINER_MODE
AC_CONFIG_AUX_DIR([.])
AC_CONFIG_FILES([Makefile])

AC_CANONICAL_TARGET

AC_PROG_CC
AC_PROG_CXX
AC_CHECK_PROGS(TAR, [gtar tar])
AC_CHECK_PROGS(PATCH, patch)
#AC_PROG_INSTALL

AC_LANG(C)
AX_COMPILER_VENDOR
AX_CC_MAXOPT

AC_LANG(C++)
AX_COMPILER_VENDOR
AX_CXX_MAXOPT

AC_ARG_ENABLE(lidia, AS_HELP_STRING([--disable-lidia],
				[Do not use the non-free library LiDIA.]), , 
		[enable_lidia=yes])
AC_SUBST(ENABLE_LIDIA, ${enable_lidia})
AM_CONDITIONAL(ENABLE_LIDIA, test x${enable_lidia} = xyes)

AC_ARG_ENABLE(4ti2, AS_HELP_STRING([--disable-4ti2],
				[Do not use 4ti2.]), , 
		[enable_4ti2=yes])
AC_SUBST(ENABLE_4TI2, ${enable_4ti2})
AM_CONDITIONAL(ENABLE_4TI2, test x${enable_4ti2} = xyes)

# For Solaris/SPARC, we need to request ABI=32 for GMP builds
# because it will build a 64-bit library instead.
case ${target_cpu} in
sparc) 
       AC_CHECK_SIZEOF(void *)
       if test x${ac_cv_sizeof_void_p} = x4; then
              gmp_configure_options="ABI=32"
       fi
       ;;
esac

# Likewise on MacOS X
case ${target_os} in
darwin*)
       AC_CHECK_SIZEOF(void *)
       if test x${ac_cv_sizeof_void_p} = x4; then
              gmp_configure_options="ABI=32"
       fi
       ;;
esac


AC_SUBST(GMP_CONFIGURE_OPTIONS, ${gmp_configure_options})

AC_OUTPUT
