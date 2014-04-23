PROJECT=cbundler
VER=$(shell cat VERSION)

all:

install:
	cp mkcbundle $(DESTDIR)/usr/bin
	cp cbundle $(DESTDIR)/usr/bin

dist:
	mkdir $(PROJECT)-$(VER)
	tar --exclude-vcs --exclude=$(PROJECT)-$(VER) -cf - . | tar -C $(PROJECT)-$(VER) -xvf -
	tar -czvf $(PROJECT)-$(VER).tar.gz $(PROJECT)-$(VER)
	rm -rf $(PROJECT)-$(VER)

