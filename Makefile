######################################################################
#
#  A minimal 'Makefile', by Alan DeKok <aland@freeradius.org>
#
#  $Id$
#
######################################################################

######################################################################
#
#   Version
#
MOD_RADIUS_MAJOR_VERSION = $(shell cat VERSION | cut -f1 -d.)
MOD_RADIUS_MINOR_VERSION = $(shell cat VERSION | cut -f2 -d.)
MOD_RADIUS_INCRM_VERSION = $(shell cat VERSION | cut -f3 -d.)
MOD_RADIUS_VERSION = $(MOD_RADIUS_MAJOR_VERSION).$(MOD_RADIUS_MINOR_VERSION).$(MOD_RADIUS_INCRM_VERSION)

######################################################################
#
#  The default rule: tell the user what to REALLY do to use
#  the module.
#

ifeq ($(which apxs), '')
all:
	@echo Can't find apxs, assuming this module will be built with apache
	@echo
	@echo Configure this module into Apache by going to the Apache root directory,
	@echo and typing:
	@echo
	@echo "     ./configure --add-module=`pwd`/mod_auth_radius.c --enable-shared=auth_radius"
	@echo
	@echo and then
	@echo
	@echo "     make"
	@echo "     make install"
	@echo
	@echo "Alternatively, if you've already built and installed Apache with"
	@echo dynamic modules, you should be able to install this module by adding apxs
	@echo to your path and executing make again 
	@echo
	@echo "     sudo make"
	@echo "     sudo make install"
	@echo	
	@echo You should add your additional site configuration options to the 'configure'
	@echo line, above.  Please read the README file for further information.
	@echo
install:
	@$(MAKE)
else
all: mod_auth_radius.o

.PHONY: install
install:
	@apxs -i -a mod_auth_radius.la
endif

mod_auth_radius.o: mod_auth_radius.c
	@apxs -Wall -a -DMOD_RADIUS_AUTH_VERSION_STRING='\"$(MOD_RADIUS_VERSION)\"' -c $<

######################################################################
#
#  Check a distribution out of the source tree, and make a tar file.
#
dist:
	tar -cf mod_auth_radius-${MOD_RADIUS_VERSION}.tar mod_auth_radius-${MOD_RADIUS_VERSION}
	rm -rf mod_auth_radius-${MOD_RADIUS_VERSION}

######################################################################
#
#  Clean up everything.
#
clean:
	@rm -f *~ *.o *.la *.so mod_auth_radius-${MOD_RADIUS_VERSION}.tar
	@rm -rf .libs/
