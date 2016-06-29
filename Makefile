INSTALL ?= install
BINDIR ?= /usr/local/bin

all:
	@echo 'Valid targets:'
	@echo '  bin/tags'
	@echo '  install'
	@echo '  uninstall'

# -O         Compile with optimizations
# -o <file>  Write output to <file>
bin/tags: tags.swift
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $< -O -o $@

# -b  Back up existing file by renaming to file.old
install: bin/tags
	@$(INSTALL) -b -v $< $(DESTDIR)$(BINDIR)

uninstall:
	@rm -f -v $(DESTDIR)$(BINDIR)/tags
	@[ -e $(DESTDIR)$(BINDIR)/tags.old ] && mv -v $(DESTDIR)$(BINDIR)/tags.old $(DESTDIR)$(BINDIR)/tags || :
