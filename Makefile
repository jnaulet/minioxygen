MACH := $(shell gcc -dumpmachine)
PERL := $(shell perl -e 'print substr($$^V, 1)')
PREFIX := /usr/local
LIBDIR:= $(PREFIX)/lib/$(MACH)/perl/$(PERL)

all:
	@perlcritic -1 minioxygen
	@perlcritic -1 MiniOxygen/*.pm

tidy:
	@perltidy -b -nst minioxygen
	@perltidy -b -nst MiniOxygen/*.pm

readme:
	@cp doc/README_head.md README.md
	@./minioxygen minioxygen MiniOxygen/*.pm >> README.md
