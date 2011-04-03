# Makefile for Tank tools.
# Check the README for more information.
#
PREFIX?=/usr
DESTDIR?=
	
all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/share/taztank
	cp -f taztank $(DESTDIR)$(PREFIX)/bin
	cp -f profile.php $(DESTDIR)$(PREFIX)/share/taztank

install-files:
	cp -a files/var $(DESTDIR)/
	chmod 0600 -p $(DESTDIR)/var/spool/cron/crontabs/root
	cp -a files/etc $(DESTDIR)/
	cp -a files/usr $(DESTDIR}/
clean:
	rm -rf _pkg
