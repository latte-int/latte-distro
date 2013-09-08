#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(latte-integrale, 1.6)
AC_CONFIG_MACRO_DIR([m4])
AC_CANONICAL_TARGET

AM_INIT_AUTOMAKE(foreign)
AM_MAINTAINER_MODE
AC_CONFIG_FILES([Makefile])

LT_INIT(disable-shared)
AM_CONDITIONAL(LATTE_ENABLE_SHARED, test x${enable_shared} = xyes)

AC_PREFIX_DEFAULT(`pwd`/dest)

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

AC_ARG_ENABLE(latte-from-svn, AS_HELP_STRING([--enable-latte-from-svn], [Get cutting edge LattE from Subversion server instead of packaged LattE.]),
			      [enable_latte_from_svn=yes])
AM_CONDITIONAL(ENABLE_LATTE_FROM_SVN, test x${enable_latte_from_svn} = xyes)

AC_ARG_ENABLE(latte, AS_HELP_STRING([--disable-latte],
				[Do not build latte.]), , 
		[enable_latte=yes])
AC_SUBST(ENABLE_LATTE, ${enable_latte})
AM_CONDITIONAL(ENABLE_LATTE, test x${enable_latte} = xyes)

# For Solaris/SPARC, we need to request ABI=32 for GMP builds
# because it will build a 64-bit library instead.
case ${target_cpu} in
*sparc*) 
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


### Find user-provided configure args that are suitable for passing
### them to our sub-configures.
### (Code adapted from autoconf/status.m4.)
  latte_sub_configure_args=
  latte_sub_configure_args_gmp=
  ac_prev=
  eval "set x $ac_configure_args"
  shift
  for ac_arg
  do
    if test -n "$ac_prev"; then
      ac_prev=
      continue
    fi
    case $ac_arg in
    -cache-file | --cache-file | --cache-fil | --cache-fi \
    | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
      ac_prev=cache_file ;;
    -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
    | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* \
    | --c=*)
      ;;
    --config-cache | -C)
      ;;
    -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
      ac_prev=srcdir ;;
    -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
      ;;
    -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
      ac_prev=prefix ;;
    -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
      ;;
    --disable-option-checking)
      ;;
    *)
      case $ac_arg in
      *\'*) ac_arg=`AS_ECHO(["$ac_arg"]) | sed "s/'/'\\\\\\\\''/g"` ;;
      esac
      AS_VAR_APPEND([latte_sub_configure_args], [" '$ac_arg'"]) 
      case $ac_arg in 
      CFLAGS*) ;;
      CXXFLAGS*) ;;
      *) AS_VAR_APPEND([latte_sub_configure_args_gmp], [" '$ac_arg'"]) ;;
      esac
      ;;
    esac
  done

  # Always prepend --prefix to ensure using the same prefix
  # in subdir configurations.
  latte_effective_prefix=$prefix
  test "x$latte_effective_prefix" = xNONE && latte_effective_prefix=$ac_default_prefix
  ac_arg="--prefix=$latte_effective_prefix"
  case $ac_arg in
  *\'*) ac_arg=`AS_ECHO(["$ac_arg"]) | sed "s/'/'\\\\\\\\''/g"` ;;
  esac
  latte_sub_configure_args="'$ac_arg' $latte_sub_configure_args"
  latte_sub_configure_args_gmp="'$ac_arg' $latte_sub_configure_args_gmp"

  # Pass --silent
  if test "$silent" = yes; then
    latte_sub_configure_args="--silent $latte_sub_configure_args"
    latte_sub_configure_args_gmp="--silent $latte_sub_configure_args_gmp"
  fi

  # Always prepend --disable-option-checking to silence warnings, since
  # different subdirs can have different --enable and --with options.
  latte_sub_configure_args="--disable-option-checking $latte_sub_configure_args"
  latte_sub_configure_args_gmp="--disable-option-checking $latte_sub_configure_args_gmp"


AC_SUBST(LATTE_SUB_CONFIGURE_ARGS, ${latte_sub_configure_args})
AC_SUBST(LATTE_SUB_CONFIGURE_ARGS_GMP, ${latte_sub_configure_args_gmp})

AC_OUTPUT
