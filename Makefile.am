## Makefile for the LattE distribution

ACLOCAL_AMFLAGS = -I m4

EXTRA_DIST = autogen.sh

## Distribution variables.

PACKAGES=gmp cddlib ntl
##PACKAGES+=cddplus  # No longer needed
if ENABLE_LIDIA
PACKAGES+=lidia
endif
if ENABLE_4TI2
PACKAGES+=glpk 4ti2
endif
if ENABLE_LATTE
PACKAGES+=latte
endif

GMP_VERSION=5.1.2
GMP_TARGZ=$(top_srcdir)/gmp-$(GMP_VERSION).tar.gz
GMP_DIR=gmp-$(GMP_VERSION)

## CDDPLUS_VERSION=077a
## CDDPLUS_TARGZ=$(top_srcdir)/cdd+-$(CDDPLUS_VERSION).tar.gz
## CDDPLUS_DIR=cdd+-$(CDDPLUS_VERSION)

CDDLIB_VERSION=0.94f+sage-patches-p8+latte-build-patch
CDDLIB_TARGZ=$(top_srcdir)/cddlib-$(CDDLIB_VERSION).tar.gz
CDDLIB_DIR=cddlib-$(CDDLIB_VERSION)

NTL_VERSION=5.5.2
NTL_TARGZ=$(top_srcdir)/ntl-$(NTL_VERSION).tar.gz
NTL_DIR=ntl-$(NTL_VERSION)

LIDIA_VERSION=2.3.0
LIDIA_BASE_PATCHLEVEL=+lattepatches
LIDIA_TARGZ=$(top_srcdir)/lidia-base-$(LIDIA_VERSION)$(LIDIA_BASE_PATCHLEVEL).tar.gz $(top_srcdir)/lidia-FF-$(LIDIA_VERSION).tar.gz $(top_srcdir)/lidia-LA-$(LIDIA_VERSION).tar.gz
LIDIA_DIR=lidia-$(LIDIA_VERSION)

LATTE_VERSION=$(PACKAGE_VERSION)
#LATTE_VERSION=1.5
LATTE_TARGZ=$(top_srcdir)/latte-int-$(LATTE_VERSION).tar.gz
if ENABLE_LATTE_FROM_SVN
LATTE_DIR=latte-svn
LATTE_SVN_URL=https://polyhedron.math.ucdavis.edu/usvn/svn/latte/trunk
else
LATTE_DIR=latte-int-$(LATTE_VERSION)
#LATTE_DIR=../latte
endif

# GLPK is a prerequisite of 4ti2
GLPK_VERSION=4.47
GLPK_TARGZ=$(top_srcdir)/glpk-$(GLPK_VERSION).tar.gz
GLPK_DIR=glpk-$(GLPK_VERSION)

FORTYTWO_VERSION=1.5.3-prerelease-2013-07-20
FORTYTWO_TARGZ=$(top_srcdir)/4ti2-$(FORTYTWO_VERSION).tar.gz
FORTYTWO_DIR=4ti2-$(FORTYTWO_VERSION)


INSTALL_DIR=$(prefix)

## Exported variables. 

LD_LIBRARY_PATH:=$(INSTALL_DIR)/lib:$(LD_LIBRARY_PATH)
PATH:=$(INSTALL_DIR)/bin:$(PATH)

export INSTALL_DIR
export MAKE
export LD_LIBRARY_PATH
export PATH

export CC
export CFLAGS
export CXX
export CXXFLAGS
export LDFLAGS

## Top-level targets.

all-local: build

build: $(PACKAGES:%=build_%)
clean-local: $(PACKAGES:%=clean_%)
	rm -f .built_*
distclean-local: $(PACKAGES:%=distclean_%)
	rm -f .configured_* .built_*
	rm -rf dest
	rm -rf */autom4te.cache
# Disable distcleancheck -- we leave the package build directories around.
distcleancheck:
	@:

.PHONY: $(PACKAGES:%=build_%) \
	$(PACKAGES:%=clean_%) \
	$(PACKAGES:%=distclean_%) \
	$(PACKAGES:%=configure_%)

EXTRA_DIST+=$(GMP_TARGZ) $(CDDLIB_TARGZ) $(NTL_TARGZ)  \
	$(LIDIA_TARGZ) $(LATTE_TARGZ) $(GLPK_TARGZ) $(FORTYTWO_TARGZ)
#EXTRA_DIST+=$(CDDPLUS_TARGZ)

# GMP.  
#
# We do not give our CFLAGS and CXXFLAGS to GMP; it is easy to
# miscompile GMP if we force it to use our values of these variables.

build_gmp: $(GMP_DIR)/.built_gmp
configure_gmp: $(GMP_DIR)/config.status
#EXTRA_DIST += gmp-4.2.1-patch
$(GMP_DIR)/.unpacked_gmp: $(GMP_TARGZ)
	gunzip < $(GMP_TARGZ) | $(TAR) xf - 					\
	&& touch $@
# (cd $(GMP_DIR) && patch -t -p1 ) < $(top_srcdir)/gmp-4.2.1-patch	
$(GMP_DIR)/config.status: $(GMP_DIR)/.unpacked_gmp
	( cd $(GMP_DIR) && unset CFLAGS CXXFLAGS; ./configure --prefix="$(INSTALL_DIR)" --enable-cxx --disable-shared $(LATTE_SUB_CONFIGURE_ARGS_GMP) $(GMP_CONFIGURE_OPTIONS) )
$(GMP_DIR)/.built_gmp: $(GMP_DIR)/config.status
	( cd $(GMP_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_gmp: 
	-( rm -f $(GMP_DIR)/.built_gmp && cd $(GMP_DIR) && $(MAKE) clean )
distclean_gmp: 
	-( rm -f $(GMP_DIR)/.built_gmp && cd $(GMP_DIR) && $(MAKE) distclean )

# NTL.

NTL_CONFIG_FILE=$(NTL_DIR)/src/makefile
build_ntl: $(NTL_DIR)/.built_ntl
configure_ntl: $(NTL_CONFIG_FILE)
$(NTL_DIR)/.unpacked_ntl: $(NTL_TARGZ)
	gunzip < $(NTL_TARGZ) | $(TAR) xf -					      \
	&& touch $@ 

### We don't pass $(LATTE_SUB_CONFIGURE_ARGS) to NTL; it does not understand common autoconf options.
if LATTE_ENABLE_SHARED
NTL_SHARED=on
else
NTL_SHARED=off
endif
$(NTL_CONFIG_FILE): $(NTL_DIR)/.unpacked_ntl $(GMP_DIR)/.built_gmp
	( cd $(NTL_DIR)/src && ./configure CC="$(CC)" CXX="$(CXX)" CFLAGS="$(CFLAGS)" CXXFLAGS="$(CXXFLAGS)" AR="$(AR)" LIBTOOL="$(abs_top_builddir)/libtool" RANLIB="$(RANLIB)" PREFIX="$(INSTALL_DIR)" GMP_PREFIX="$(INSTALL_DIR)" NTL_GMP_LIP=on SHARED=$(NTL_SHARED) )

$(NTL_DIR)/.built_ntl: $(NTL_CONFIG_FILE) $(GMP_DIR)/.built_gmp
	( cd $(NTL_DIR)/src && $(MAKE) setup1 && $(MAKE) setup2 && $(MAKE) setup3 && $(MAKE) setup4 && $(MAKE) ntl.a && $(MAKE) install ) \
	&& touch $@

clean_ntl: 
	-( rm -f $(NTL_DIR)/.built_ntl && cd $(NTL_DIR)/src && $(MAKE) clean )
distclean_ntl: 
	-( rm -f $(NTL_DIR)/.built_ntl && cd $(NTL_DIR)/src && $(MAKE) clean; rm -f $(NTL_CONFIG_FILE) )

# LiDIA.

build_lidia: $(LIDIA_DIR)/.built_lidia
configure_lidia: $(LIDIA_DIR)/config.status $(GMP_DIR)/.built_gmp
#EXTRA_DIST += lidia-2.2.0.patch lidia-2.2.0-2.patch
$(LIDIA_DIR)/.unpacked_lidia: $(LIDIA_TARGZ)
	for a in $(LIDIA_TARGZ); do					\
	  gunzip < $$a | $(TAR) xf - || exit 1;				\
	done 								\
	&& touch $@
$(LIDIA_DIR)/config.status: $(LIDIA_DIR)/.unpacked_lidia $(GMP_DIR)/.built_gmp
	( cd $(LIDIA_DIR) && ./configure --with-arithmetic=gmp --disable-nf --disable-ec --disable-eco --disable-gec --with-extra-includes="$(INSTALL_DIR)"/include --with-extra-libs="$(INSTALL_DIR)"/lib --prefix="$(INSTALL_DIR)"  --disable-shared $(LATTE_SUB_CONFIGURE_ARGS)) 
# LiDIA 2.2.0 installs its headers into lidia/ but expects them in LiDIA!?!
# So we make a symbolic link, just in case.
$(LIDIA_DIR)/.built_lidia: $(LIDIA_DIR)/config.status $(GMP_DIR)/.built_gmp
	( cd $(LIDIA_DIR) && $(MAKE) && $(MAKE) install ) && ( cd "$(INSTALL_DIR)"/include && if [ ! -r LiDIA ] ; then ln -s lidia LiDIA; fi  || true ) && touch $@
clean_lidia: 
	-( rm -f $(LIDIA_DIR)/.built_lidia && cd $(LIDIA_DIR) && $(MAKE) clean )
distclean_lidia: 
	-( rm -f $(LIDIA_DIR)/.built_lidia && cd $(LIDIA_DIR) && $(MAKE) distclean )

# cddlib.
#
# cddlib 094b has a hard-coded location of GMP in /usr/local in its Makefile.am(!)
# We work around this by passing LDFLAGS to both configure and make.
build_cddlib: $(CDDLIB_DIR)/.built_cddlib
configure_cddlib: $(CDDLIB_DIR)/config.status $(GMP_DIR)/.built_gmp
$(CDDLIB_DIR)/.unpacked_cddlib: $(CDDLIB_TARGZ)
	for a in $(CDDLIB_TARGZ); do						 \
	  gunzip < $$a | $(TAR) xf - || exit 1;					 \
	done 									 \
	&& touch $@
## && (cd $(CDDLIB_DIR) && patch -t -p1 ) < $(top_srcdir)/cddlib-shared-library.patch \
## EXTRA_DIST += cddlib-shared-library.patch
$(CDDLIB_DIR)/config.status: $(CDDLIB_DIR)/.unpacked_cddlib $(GMP_DIR)/.built_gmp
	( cd $(CDDLIB_DIR) && ./configure --prefix="$(INSTALL_DIR)"  --disable-shared $(LATTE_SUB_CONFIGURE_ARGS) CXX="$(CXX)" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" ) 
$(CDDLIB_DIR)/.built_cddlib: $(CDDLIB_DIR)/config.status $(GMP_DIR)/.built_gmp
	( cd $(CDDLIB_DIR) && $(MAKE) LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" && $(MAKE) install ) && touch $@
clean_cddlib: 
	-( rm -f $(CDDLIB_DIR)/.built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) clean )
distclean_cddlib: 
	-( rm -f $(CDDLIB_DIR)/.built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) distclean )

# cdd+.

## CDDPLUS_VARIABLES=CC="$(CXX)" LIBDIR="$(INSTALL_DIR)"/lib GMPLIBDIR="$(INSTALL_DIR)"/lib INCLUDEDIR="$(INSTALL_DIR)"/include GMPINCLUDEDIR="$(INSTALL_DIR)"/include OPTFLAGS="$(CXXFLAGS)"
## build_cddplus: $(CDDPLUS_DIR)/.built_cddplus
## configure_cddplus: .unpacked_cddplus $(GMP_DIR)/.built_gmp
## EXTRA_DIST += cdd+-077a.patch
## .unpacked_cddplus: $(CDDPLUS_TARGZ)
## 	for a in $(CDDPLUS_TARGZ); do						\
## 	  gunzip < $$a | $(TAR) xf - || exit 1;					\
## 	done									\
## 	&& (cd $(CDDPLUS_DIR) && $(PATCH) -p0) < $(top_srcdir)/cdd+-077a.patch	\
## 	&& touch $@
## $(CDDPLUS_DIR)/.built_cddplus: .unpacked_cddplus $(GMP_DIR)/.built_gmp
## 	( cd $(CDDPLUS_DIR) && $(MAKE) $(CDDPLUS_VARIABLES) cddr+ cddf+ ) && $(mkinstalldirs) "$(INSTALL_DIR)"/bin && $(INSTALL) $(CDDPLUS_DIR)/cddr+ $(CDDPLUS_DIR)/cddf+ "$(INSTALL_DIR)"/bin && touch $@
## clean_cddplus: 
## 	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )
## distclean_cddplus: 
## 	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )

# GLPK.
build_glpk: $(GLPK_DIR)/.built_glpk
configure_glpk: $(GLPK_DIR)/config.status $(GMP_DIR)/.built_gmp
$(GLPK_DIR)/.unpacked_glpk: $(GLPK_TARGZ)
	gunzip < $(GLPK_TARGZ) | $(TAR) xf - 					\
	&& touch $@
$(GLPK_DIR)/config.status: $(GLPK_DIR)/.unpacked_glpk $(GMP_DIR)/.built_gmp
	( cd $(GLPK_DIR) && ./configure --prefix="$(INSTALL_DIR)" --disable-shared $(GLPK_CONFIGURE_OPTIONS) $(LATTE_SUB_CONFIGURE_ARGS) CC="$(CC)" CXX="$(CXX)" CPPFLAGS="$(CPPFLAGS) -I$(INSTALL_DIR)/include" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" )
$(GLPK_DIR)/.built_glpk: $(GLPK_DIR)/config.status
	( cd $(GLPK_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_glpk: 
	-( rm -f $(GLPK_DIR)/.built_glpk && cd $(GLPK_DIR) && $(MAKE) clean )
distclean_glpk: 
	-( rm -f $(GLPK_DIR)/.built_glpk && cd $(GLPK_DIR) && $(MAKE) distclean )

# 4ti2.
build_4ti2: $(FORTYTWO_DIR)/.built_4ti2
configure_4ti2: $(FORTYTWO_DIR)/config.status $(GLPK_DIR)/.built_glpk $(GMP_DIR)/.built_gmp
$(FORTYTWO_DIR)/.unpacked_4ti2: $(FORTYTWO_TARGZ)
	gunzip < $(FORTYTWO_TARGZ) | $(TAR) xf - 					\
	&& touch $@
$(FORTYTWO_DIR)/config.status: $(FORTYTWO_DIR)/.unpacked_4ti2 $(GLPK_DIR)/.built_glpk $(GMP_DIR)/.built_gmp
	( cd $(FORTYTWO_DIR) &&  ./configure --prefix="$(INSTALL_DIR)" --with-gmp="$(INSTALL_DIR)" --with-glpk="$(INSTALL_DIR)" --disable-shared $(FORTYTWO_CONFIGURE_OPTIONS) $(LATTE_SUB_CONFIGURE_ARGS) CC="$(CC)" CXX="$(CXX)" CPPFLAGS="$(CPPFLAGS) -I$(INSTALL_DIR)/include" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib")
## We currently have header file clashes between zsolve and groebner on Mac OS,
## due to semi-case-insensitivity.  Work around for now, by only installing 
## the header files of groebner -- we only need those... 
## (This is already fixed for the upcoming 4ti2 releases.)
$(FORTYTWO_DIR)/.built_4ti2: $(FORTYTWO_DIR)/config.status
	( cd $(FORTYTWO_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_4ti2: 
	-( rm -f $(FORTYTWO_DIR)/.built_4ti2 && cd $(FORTYTWO_DIR) && $(MAKE) clean )
distclean_4ti2: 
	-( rm -f $(FORTYTWO_DIR)/.built_4ti2 && cd $(FORTYTWO_DIR) && $(MAKE) distclean )

# LattE.

if ENABLE_LIDIA
BUILT_LIDIA=$(LIDIA_DIR)/.built_lidia
else
BUILT_LIDIA=
endif

if ENABLE_4TI2
BUILT_4TI2=$(FORTYTWO_DIR)/.built_4ti2
else
BUILT_4TI2=
endif

build_latte: .built_latte
configure_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp $(CDDLIB_DIR)/.built_cddlib  $(NTL_DIR)/.built_ntl
##$(CDDPLUS_DIR)/.built_cddplus  # no longer needed
if ENABLE_LATTE_FROM_SVN
$(LATTE_DIR)/.unpacked_latte: 
	svn co $(LATTE_SVN_URL) $(LATTE_DIR)  && (cd $(LATTE_DIR) && ./autogen.sh) && touch $@
else
$(LATTE_DIR)/.unpacked_latte: $(LATTE_TARGZ)
	for a in $(LATTE_TARGZ); do \
	  gunzip < $$a | $(TAR) xf - || exit 1; \
	done && touch $@
endif
$(LATTE_DIR)/config.status: $(LATTE_DIR)/.unpacked_latte $(GMP_DIR)/.built_gmp $(CDDLIB_DIR)/.built_cddlib $(BUILT_LIDIA) $(NTL_DIR)/.built_ntl $(BUILT_4TI2)
	( cd $(LATTE_DIR) && ./configure --with-default="$(INSTALL_DIR)" --prefix="$(INSTALL_DIR)" --enable-relocatable --disable-shared $(LATTE_SUB_CONFIGURE_ARGS)) 
##$(CDDPLUS_DIR)/.built_cddplus  # no longer needed
.built_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp $(CDDLIB_DIR)/.built_cddlib $(BUILT_LIDIA) $(NTL_DIR)/.built_ntl $(BUILT_4TI2)
	( cd $(LATTE_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
##$(CDDPLUS_DIR)/.built_cddplus 
clean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) clean )
distclean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) distclean )


## Uninstalling is too hairy, just disable the check for it:
distuninstallcheck:
	@:


## Maintainer targets

update-changelog: 
	(cd $(srcdir) && svn2cl --output=ChangeLog.svn2cl --authors=.svn2cl-authors)

