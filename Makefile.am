## Makefile for the LattE distribution

ACLOCAL_AMFLAGS = -I m4

## Distribution variables.

PACKAGES=gmp cddplus cddlib ntl latte
if ENABLE_LIDIA
PACKAGES+=lidia
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

LATTE_VERSION=1.2-mk-0.5
LATTE_TARGZ=$(top_srcdir)/latte-$(LATTE_VERSION).tar.gz
LATTE_DIR=latte-$(LATTE_VERSION)

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

# GMP.  
#
# We do not give our CFLAGS and CXXFLAGS to GMP; it is easy to
# miscompile GMP if we force it to use our values of these variables.

build_gmp: $(GMP_DIR)/.built_gmp
configure_gmp: $(GMP_DIR)/config.status
$(GMP_DIR)/.unpacked_gmp: $(GMP_TARGZ)
	$(TAR) xfz $(GMP_TARGZ)							\
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
	$(TAR) xfz $(NTL_TARGZ) && touch $@
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
$(LIDIA_DIR)/.unpacked_lidia: $(LIDIA_TARGZ)
	for a in $(LIDIA_TARGZ); do					\
	  $(TAR) xfz $$a || exit 1;					\
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
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
$(CDDLIB_DIR)/config.status: .unpacked_cddlib $(GMP_DIR)/.built_gmp
	( cd $(CDDLIB_DIR) && ./configure CXX="$(CC)" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" --prefix=$(INSTALL_DIR)  --disable-shared) 
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
.unpacked_cddplus: $(CDDPLUS_TARGZ)
	for a in $(CDDPLUS_TARGZ); do						\
	  $(TAR) xfz $$a || exit 1;						\
	done									\
	&& (cd $(CDDPLUS_DIR) && $(PATCH) -p1) < $(top_srcdir)/cdd+-077.patch 	\
	&& touch $@
$(CDDPLUS_DIR)/.built_cddplus: .unpacked_cddplus $(GMP_DIR)/.built_gmp
	( cd $(CDDPLUS_DIR) && $(MAKE) $(CDDPLUS_VARIABLES) cddr+ cddf+ && $(mkinstalldirs) $(INSTALL_DIR)/bin && $(INSTALL) cddr+ cddf+ $(INSTALL_DIR)/bin ) && touch $@
clean_cddplus: 
	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )
distclean_cddplus: 
	-( rm -f $(CDDPLUS_DIR)/.built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )

# LattE.

if ENABLE_LIDIA
BUILT_LIDIA=$(LIDIA_DIR)/.built_lidia
else
BUILT_LIDIA=
endif

build_latte: .built_latte
configure_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus  .built_ntl
.unpacked_latte: $(LATTE_TARGZ)
	for a in $(LATTE_TARGZ); do \
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
$(LATTE_DIR)/config.status: .unpacked_latte $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus $(BUILT_LIDIA) .built_ntl
	( cd $(LATTE_DIR) && ./configure --with-default=$(INSTALL_DIR) --prefix=$(INSTALL_DIR) ) 
.built_latte: $(LATTE_DIR)/config.status $(GMP_DIR)/.built_gmp .built_cddlib $(CDDPLUS_DIR)/.built_cddplus $(BUILT_LIDIA) .built_ntl
	( cd $(LATTE_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) clean )
distclean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) distclean )

## Maintainer targets

EXTRA_DIST=$(GMP_TARGZ) $(CDDPLUS_TARGZ) $(CDDLIB_TARGZ) $(NTL_TARGZ)  \
	$(LIDIA_TARGZ) $(LATTE_TARGZ)
