INSTALL ?= install
prefix ?= /usr/local
bindir ?= $(prefix)/bin
# -O  Compile with optimizations
CFLAGS := -O

all: bin/tags

bin/tags: tags.swift
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $< $(CFLAGS) -o $@

# -b  Back up existing file by renaming to file.old
install: bin/tags
	@$(INSTALL) -b -v $< $(DESTDIR)$(bindir)

uninstall:
	@rm -f -v $(DESTDIR)$(bindir)/tags
	@[ -e $(DESTDIR)$(bindir)/tags.old ] && mv -v $(DESTDIR)$(bindir)/tags.old $(DESTDIR)$(bindir)/tags || :

clean:
	@rm -rf -v bin
