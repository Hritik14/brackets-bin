TMPDIR := $(shell mktemp -d)
URL=https://github.com/adobe/brackets/releases/download/release-1.14.1/Brackets.Release.1.14.1.64-bit.deb

update: archive
	rm -f data.tar.xz*
	split -b 50M $(TMPDIR)/combined/data.tar.xz data.tar.xz
	rm -rf $(TMPDIR)

archive: patch
	mkdir $(TMPDIR)/combined
	tar caf $(TMPDIR)/combined/data.tar.xz --checkpoint=5000 -C $(TMPDIR) usr opt

patch: brackets.deb libcef.so
	7z x -o$(TMPDIR) brackets.deb
	tar -xf $(TMPDIR)/data.tar -C $(TMPDIR)
	cp libcef.so $(TMPDIR)/opt/brackets/libcef.so

brackets.deb:
	wget $(URL) -q --progress=bar --show-progress -O brackets.deb
