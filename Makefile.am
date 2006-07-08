## Makefile for the LattE distribution

ACLOCAL_AMFLAGS = -I m4

## Distribution variables.

PACKAGES=gmp cddplus cddlib ntl lidia latte

GMP_VERSION=4.1.4
GMP_TARGZ=gmp-$(GMP_VERSION).tar.gz
GMP_DIR=gmp-$(GMP_VERSION)

CDDPLUS_VERSION=077
CDDPLUS_TARGZ=cdd+-$(CDDPLUS_VERSION).tar.gz
CDDPLUS_DIR=$(CURDIR)/cdd+-$(CDDPLUS_VERSION)

CDDLIB_VERSION=094b
CDDLIB_TARGZ=cddlib-$(CDDLIB_VERSION).tar.gz
CDDLIB_DIR=$(CURDIR)/cddlib-$(CDDLIB_VERSION)

NTL_VERSION=5.4
NTL_TARGZ=ntl-$(NTL_VERSION).tar.gz
NTL_DIR=$(CURDIR)/ntl-$(NTL_VERSION)

LIDIA_VERSION=2.2.0
LIDIA_TARGZ=lidia-base-$(LIDIA_VERSION).tar.gz lidia-FF-$(LIDIA_VERSION).tar.gz lidia-LA-$(LIDIA_VERSION).tar.gz
LIDIA_DIR=lidia-$(LIDIA_VERSION)

LATTE_VERSION=1.2-mk-0.5
LATTE_TARGZ=latte-$(LATTE_VERSION).tar.gz
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
clean: $(PACKAGES:%=clean_%)
	rm -f .built_*
distclean: $(PACKAGES:%=distclean_%)
	rm -f .configured_* .built_*
	rm -rf dest
	find . -name "*~" -o -name ".*~" -o -name ".*#*" -o -name "*#*" | xargs rm -f
	rm -rf */autom4te.cache

.PHONY: $(PACKAGES:%=build_%) \
	$(PACKAGES:%=clean_%) \
	$(PACKAGES:%=distclean_%) \
	$(PACKAGES:%=configure_%)

# GMP.
build_gmp: .built_gmp
configure_gmp: $(GMP_DIR)/config.status
.unpacked_gmp: $(GMP_TARGZ)
	$(TAR) xfz $(GMP_TARGZ) && touch $@
$(GMP_DIR)/config.status: .unpacked_gmp
	( cd $(GMP_DIR) && ./configure --prefix=$(INSTALL_DIR) --enable-cxx --disable-shared  $(GMP_CONFIGURE_OPTIONS) )
.built_gmp: $(GMP_DIR)/config.status
	( cd $(GMP_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_gmp: 
	-( rm -f .built_gmp && cd $(GMP_DIR) && $(MAKE) clean )
distclean_gmp: 
	-( rm -f .built_gmp && cd $(GMP_DIR) && $(MAKE) distclean )

# NTL.

NTL_CONFIG_FILE=$(NTL_DIR)/src/makefile
build_ntl: .built_ntl
configure_ntl: $(NTL_CONFIG_FILE)
.unpacked_ntl: $(NTL_TARGZ)
	$(TAR) xfz $(NTL_TARGZ) && touch $@
$(NTL_CONFIG_FILE): .unpacked_ntl .built_gmp
	( cd $(NTL_DIR)/src && ./configure PREFIX=$(INSTALL_DIR) GMP_PREFIX=$(INSTALL_DIR) NTL_GMP_LIP=on ) 
.built_ntl: $(NTL_CONFIG_FILE) .built_gmp
	( cd $(NTL_DIR)/src && $(MAKE) setup1 && $(MAKE) setup2 && $(MAKE) setup3 && $(MAKE) setup4 && $(MAKE) ntl.a && $(MAKE) install ) && touch $@
clean_ntl: 
	-( rm -f .built_ntl && cd $(NTL_DIR) && $(MAKE) clean )
distclean_ntl: 
	-( rm -f .built_ntl && cd $(NTL_DIR) && $(MAKE) distclean )

# LiDIA.

build_lidia: .built_lidia
configure_lidia: $(LIDIA_DIR)/config.status .built_gmp
.unpacked_lidia: $(LIDIA_TARGZ)
	for a in $(LIDIA_TARGZ); do \
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
$(LIDIA_DIR)/config.status: .unpacked_lidia .built_gmp
	( cd $(LIDIA_DIR) && ./configure --with-arithmetic=gmp --disable-nf --disable-ec --disable-eco --disable-gec --with-extra-includes=$(INSTALL_DIR)/include --with-extra-libs=$(INSTALL_DIR)/lib --prefix=$(INSTALL_DIR)  --disable-shared) 
# LiDIA 2.2.0 installs its headers into lidia/ but expects them in LiDIA!?!
# So we make a symbolic link, just in case.
.built_lidia: $(LIDIA_DIR)/config.status .built_gmp
	( cd $(LIDIA_DIR) && $(MAKE) && $(MAKE) install ) && ( cd $(INSTALL_DIR)/include && ln -s lidia LiDIA || true ) && touch $@
clean_lidia: 
	-( rm -f .built_lidia && cd $(LIDIA_DIR) && $(MAKE) clean )
distclean_lidia: 
	-( rm -f .built_lidia && cd $(LIDIA_DIR) && $(MAKE) distclean )

# cddlib.

build_cddlib: .built_cddlib
configure_cddlib: $(CDDLIB_DIR)/config.status .built_gmp
.unpacked_cddlib: $(CDDLIB_TARGZ)
	for a in $(CDDLIB_TARGZ); do \
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
$(CDDLIB_DIR)/config.status: .unpacked_cddlib .built_gmp
	( cd $(CDDLIB_DIR) && ./configure CXX=$(CC) CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/include" LDFLAGS="$(LDFLAGS) -L$(INSTALL_DIR)/lib" --prefix=$(INSTALL_DIR)  --disable-shared) 
.built_cddlib: $(CDDLIB_DIR)/config.status .built_gmp
	( cd $(CDDLIB_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_cddlib: 
	-( rm -f .built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) clean )
distclean_cddlib: 
	-( rm -f .built_cddlib && cd $(CDDLIB_DIR) && $(MAKE) distclean )

# cdd+.

CDDPLUS_VARIABLES=CC=$(CXX) LIBDIR=$(INSTALL_DIR)/lib GMPLIBDIR=$(INSTALL_DIR)/lib INCLUDEDIR=$(INSTALL_DIR)/include GMPINCLUDEDIR=$(INSTALL_DIR)/include OPTFLAGS="$(CXXFLAGS)"
build_cddplus: .built_cddplus
configure_cddplus: .unpacked_cddplus .built_gmp
.unpacked_cddplus: $(CDDPLUS_TARGZ)
	for a in $(CDDPLUS_TARGZ); do \
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
.built_cddplus: .unpacked_cddplus .built_gmp
	( cd $(CDDPLUS_DIR) && $(MAKE) $(CDDPLUS_VARIABLES) cddr+ cddf+ && $(mkinstalldirs) $(INSTALL_DIR)/bin && $(INSTALL) cddr+ cddf+ $(INSTALL_DIR)/bin ) && touch $@
clean_cddplus: 
	-( rm -f .built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )
distclean_cddplus: 
	-( rm -f .built_cddplus && cd $(CDDPLUS_DIR) && $(MAKE) clean )

# LattE.

build_latte: .built_latte
configure_latte: $(LATTE_DIR)/config.status .built_gmp .built_cddlib .built_cddplus .built_lidia .built_ntl
.unpacked_latte: $(LATTE_TARGZ)
	for a in $(LATTE_TARGZ); do \
	  $(TAR) xfz $$a || exit 1; \
	done && touch $@
$(LATTE_DIR)/config.status: .unpacked_latte .built_gmp .built_cddlib .built_cddplus .built_lidia .built_ntl
	( cd $(LATTE_DIR) && ./configure --with-default=$(INSTALL_DIR) --prefix=$(INSTALL_DIR) ) 
.built_latte: $(LATTE_DIR)/config.status .built_gmp .built_cddlib .built_cddplus .built_lidia .built_ntl
	( cd $(LATTE_DIR) && $(MAKE) && $(MAKE) install ) && touch $@
clean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) clean )
distclean_latte: 
	-( rm -f .built_latte && cd $(LATTE_DIR) && $(MAKE) distclean )

## Maintainer targets

EXTRA_DIST=$(GMP_TARGZ) $(CDDPLUS_TARGZ) $(CDDLIB_TARGZ) $(NTL_TARGZ)  \
	$(LIDIA_TARGZ) $(LATTE_TARGZ)
