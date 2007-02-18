## Makefile for the LattE distribution

ACLOCAL_AMFLAGS = -I m4

## Distribution variables.

PACKAGES=gmp cddplus cddlib ntl latte
if ENABLE_LIDIA
PACKAGES+=lidia
endif
if ENABLE_4TI2
PACKAGES+=glpk 4ti2
endif

GMP_VERSION=4.2.1
GMP_TARGZ=$(top_srcdir)/gmp-$(GMP_VERSION).tar.gz
GMP_DIR=gmp-$(GMP_VERSION)

CDDPLUS_VERSION=077
CDDPLUS_TARGZ=$(top_srcdir)/cdd+-$(CDDPLUS_VERSION).tar.gz
CDDPLUS_DIR=$(CURDIR)/cdd+-$(CDDPLUS_VERSION)

CDDLIB_VERSION=094b
CDDLIB_TARGZ=$(top_srcdir)/cddlib-$(CDDLIB_VERSION).tar.gz
CDDLIB_DIR=$(CURDIR)/cddlib-$(CDDLIB_VERSION)

NTL_VERSION=5.4
NTL_TARGZ=$(top_srcdir)/ntl-$(NTL_VERSION).tar.gz
NTL_DIR=$(CURDIR)/ntl-$(NTL_VERSION)

LIDIA_VERSION=2.2.0
LIDIA_TARGZ=$(top_srcdir)/lidia-base-$(LIDIA_VERSION).tar.gz $(top_srcdir)/lidia-FF-$(LIDIA_VERSION).tar.gz $(top_srcdir)/lidia-LA-$(LIDIA_VERSION).tar.gz
LIDIA_DIR=lidia-$(LIDIA_VERSION)

LATTE_VERSION=$(PACKAGE_VERSION)
LATTE_TARGZ=$(top_srcdir)/latte-$(LATTE_VERSION).tar.gz
LATTE_DIR=latte-$(LATTE_VERSION)

# GLPK is a prerequisite of 4ti2
GLPK_VERSION=4.13
GLPK_TARGZ=$(top_srcdir)/glpk-$(GLPK_VERSION).tar.gz
GLPK_DIR=glpk-$(GLPK_VERSION)

FORTYTWO_VERSION=1.3.1+autoconf-0.1
FORTYTWO_TARGZ=$(top_srcdir)/4ti2-$(FORTYTWO_VERSION).tar.gz
FORTYTWO_DIR=4ti2-$(FORTYTWO_VERSION)


INSTALL_DIR=$(CURDIR)/dest

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

.PHONY: $(PACKAGES:%=build_%) \
	$(PACKAGES:%=clean_%) \
	$(PACKAGES:%=distclean_%) \
	$(PACKAGES:%=configure_%)

EXTRA_DIST=$(GMP_TARGZ) $(CDDPLUS_TARGZ) $(CDDLIB_TARGZ) $(NTL_TARGZ)  \
	$(LIDIA_TARGZ) $(LATTE_TARGZ) $(GLPK_TARGZ) $(FORTYTWO_TARGZ)

# GMP.  
#
# We do not give our CFLAGS and CXXFLAGS to GMP; it is easy to
# miscompile GMP if we force it to use our values of these variables.

build_gmp: $(GMP_DIR)/.built_gmp
configure_gmp: $(GMP_DIR)/config.status
EXTRA_DIST += gmp-4.2.1-patch
$(GMP_DIR)/.unpacked_gmp: $(GMP_TARGZ)
	gunzip < $(GMP_TARGZ) | $(TAR) xf - 					\
	&& (cd $(GMP_DIR) && patch -t -p1 ) < $(top_srcdir)/gmp-4.2.1-patch	\
	&& touch $@
$(GMP_DIR)/config.status: $(GMP_DIR)/.unpacked_gmp
	( cd $(GMP_DIR) && unset CFLAGS CXXFLAGS; ./configure --prefix=$(INSTALL_DIR) --enable-cxx --disable-shared  $(GMP_CONFIGURE_OPTIONS) )
$(GMP_DIR)/.built_gmp: $(GMP_DIR)/config.status
	( cd $(GMP_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_gmp: 
	-( rm -f $(GMP_DIR)/.built_gmp && cd $(GMP_DIR) && $(MAKE) clean )
distclean_gmp: 
	-( rm -f $(GMP_DIR)/.built_gmp && cd $(GMP_DIR) && $(MAKE) distclean )

# NTL.

NTL_CONFIG_FILE=$(NTL_DIR)/src/makefile
build_ntl: .built_ntl
configure_ntl: $(NTL_CONFIG_FILE)
.unpacked_ntl: $(NTL_TARGZ)
	gunzip < $(NTL_TARGZ) | $(TAR) xf - && touch $@
$(NTL_CONFIG_FILE): .unpacked_ntl $(GMP_DIR)/.built_gmp
	( cd $(NTL_DIR)/src && ./configure CC="$(CC)" CXX="$(CXX)" CFLAGS="$(CFLAGS)" CXXFLAGS="$(CXXFLAGS)" PREFIX=$(INSTALL_DIR) GMP_PREFIX=$(INSTALL_DIR) NTL_GMP_LIP=on ) 
.built_ntl: $(NTL_CONFIG_FILE) $(GMP_DIR)/.built_gmp
	( cd $(NTL_DIR)/src && $(MAKE) setup1 && $(MAKE) setup2 && $(MAKE) setup3 && $(MAKE) setup4 && $(MAKE) ntl.a && $(MAKE) install ) && touch $@
clean_ntl: 
	-( rm -f .built_ntl && cd $(NTL_DIR)/src && $(MAKE) clean )
distclean_ntl: 
	-( rm -f .built_ntl && cd $(NTL_DIR)/src && $(MAKE) clean; rm -f $(NTL_CONFIG_FILE) )

# LiDIA.

build_lidia: $(LIDIA_DIR)/.built_lidia
configure_lidia: $(LIDIA_DIR)/config.status $(GMP_DIR)/.built_gmp
EXTRA_DIST += lidia-2.2.0.patch lidia-2.2.0-2.patch
$(LIDIA_DIR)/.unpacked_lidia: $(LIDIA_TARGZ)
	for a in $(LIDIA_TARGZ); do					\
	  gunzip < $$a | $(TAR) xf - || exit 1;				\
	done 								\
	&& (cd $(LIDIA_DIR)						\
		&& $(PATCH) -t -p0) < $(top_srcdir)/lidia-2.2.0.patch 	\
	&& (cd $(LIDIA_DIR)						\
		&& $(PATCH) -t -p0) < $(top_srcdir)/lidia-2.2.0-2.patch	\
	&& touch $@
$(LIDIA_DIR)/config.status: $(LIDIA_DIR)/.unpacked_lidia $(GMP_DIR)/.built_gmp
	( cd $(LIDIA_DIR) && ./configure --with-arithmetic=gmp --disable-nf --disable-ec --disable-eco --disable-gec --with-extra-includes=$(INSTALL_DIR)/include --with-extra-libs=$(INSTALL_DIR)/lib --prefix=$(INSTALL_DIR)  --disable-shared) 
# LiDIA 2.2.0 installs its headers into lidia/ but expects them in LiDIA!?!
# So we make a symbolic link, just in case.
$(LIDIA_DIR)/.built_lidia: $(LIDIA_DIR)/config.status $(GMP_DIR)/.built_gmp
	( cd $(LIDIA_DIR) && $(MAKE) && $(MAKE) install ) && ( cd $(INSTALL_DIR)/include && ln -s lidia LiDIA || true ) && touch $@
clean_lidia: 
	-( rm -f $(LIDIA_DIR)/.built_lidia && cd $(LIDIA_DIR) && $(MAKE) clean )
distclean_lidia: 
	-( rm -f $(LIDIA_DIR)/.built_lidia && cd $(LIDIA_DIR) && $(MAKE) distclean )

# cddlib.
#
# cddlib 094b has a hard-coded location of GMP in /usr/local in its Makefile.am(!)
# We work around this by passing LDFLAGS to both configure and make.
build_cddlib: .built_cddlib
configure_cddlib: $(CDDLIB_DIR)/config.status $(GMP_DIR)/.built_gmp
.unpacked_cddlib: $(CDDLIB_TARGZ)
	for a in $(CDDLIB_TARGZ); do \
	  gunzip < $$a | $(TAR) xf - || exit 1; \
	done && touch $@
$(CDDLIB_DIR)/config.status: .unpacked_cddlib $(GMP_DIR)/.built_gmp
	( cd $(CDDLIB_DIR) && ./configure CXX="$(CXX)" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" --prefix=$(INSTALL_DIR)  --disable-shared) 
.built_cddlib: $(CDDLIB_DIR)/config.status $(GMP_DIR)/.built_gmp
	( cd $(CDDLIB_DIR) && $(MAKE) LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" && $(MAKE) install ) && touch $@
clean_cddlib: 
	-( rm -f .built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) clean )
distclean_cddlib: 
	-( rm -f .built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) distclean )

# cdd+.

CDDPLUS_VARIABLES=CC="$(CXX)" LIBDIR=$(INSTALL_DIR)/lib GMPLIBDIR=$(INSTALL_DIR)/lib INCLUDEDIR=$(INSTALL_DIR)/include GMPINCLUDEDIR=$(INSTALL_DIR)/include OPTFLAGS="$(CXXFLAGS)"
build_cddplus: $(CDDPLUS_DIR)/.built_cddplus
configure_cddplus: .unpacked_cddplus $(GMP_DIR)/.built_gmp
EXTRA_DIST += cdd+-077.patch
.unpacked_cddplus: $(CDDPLUS_TARGZ)
	for a in $(CDDPLUS_TARGZ); do						\
	  gunzip < $$a | $(TAR) xf - || exit 1;					\
	done									\
	&& (cd $(CDDPLUS_DIR) && $(PATCH) -p1) < $(top_srcdir)/cdd+-077.patch 	\
	&& touch $@
$(CDDPLUS_DIR)/.built_cddplus: .unpacked_cddplus $(GMP_DIR)/.built_gmp
	( cd $(CDDPLUS_DIR) && $(MAKE) $(CDDPLUS_VARIABLES) cddr+ cddf+ && $(mkinstalldirs) $(INSTALL_DIR)/bin && $(INSTALL) cddr+ cddf+ $(INSTALL_DIR)/bin ) && touch $@
clean_cddplus: 
	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )
distclean_cddplus: 
	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )

# GLPK.
build_glpk: $(GLPK_DIR)/.built_glpk
configure_glpk: $(GLPK_DIR)/config.status
$(GLPK_DIR)/.unpacked_glpk: $(GLPK_TARGZ)
	gunzip < $(GLPK_TARGZ) | $(TAR) xf - 					\
	&& touch $@
$(GLPK_DIR)/config.status: $(GLPK_DIR)/.unpacked_glpk
	( cd $(GLPK_DIR) && CC="$(CC)" CXX="$(CXX)" CPPFLAGS="$(CPPFLAGS) -I$(INSTALL_DIR)/include" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" ./configure --prefix=$(INSTALL_DIR) --disable-shared $(GLPK_CONFIGURE_OPTIONS) )
$(GLPK_DIR)/.built_glpk: $(GLPK_DIR)/config.status
	( cd $(GLPK_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_glpk: 
	-( rm -f $(GLPK_DIR)/.built_glpk && cd $(GLPK_DIR) && $(MAKE) clean )
distclean_glpk: 
	-( rm -f $(GLPK_DIR)/.built_glpk && cd $(GLPK_DIR) && $(MAKE) distclean )

# 4ti2.
build_4ti2: $(FORTYTWO_DIR)/.built_4ti2
configure_4ti2: $(FORTYTWO_DIR)/config.status
$(FORTYTWO_DIR)/.unpacked_4ti2: $(FORTYTWO_TARGZ)
	gunzip < $(FORTYTWO_TARGZ) | $(TAR) xf - 					\
	&& touch $@
$(FORTYTWO_DIR)/config.status: $(FORTYTWO_DIR)/.unpacked_4ti2
	( cd $(FORTYTWO_DIR) && CC="$(CC)" CXX="$(CXX)" CPPFLAGS="$(CPPFLAGS) -I$(INSTALL_DIR)/include" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" CXXFLAGS="$(CXXFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" ./configure --prefix=$(INSTALL_DIR) --disable-shared $(FORTYTWO_CONFIGURE_OPTIONS) )
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
configure_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus  .built_ntl
.unpacked_latte: $(LATTE_TARGZ)
	for a in $(LATTE_TARGZ); do \
	  gunzip < $$a | $(TAR) xf - || exit 1; \
	done && touch $@
$(LATTE_DIR)/config.status: .unpacked_latte $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus $(BUILT_LIDIA) .built_ntl $(BUILT_4TI2)
	( cd $(LATTE_DIR) && ./configure --with-default=$(INSTALL_DIR) --prefix=$(INSTALL_DIR) ) 
.built_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus $(BUILT_LIDIA) .built_ntl $(BUILT_4TI2)
	( cd $(LATTE_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) clean )
distclean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) distclean )

## Maintainer targets

