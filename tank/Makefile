# Makefile for Tank tools.
# Check the README for more information.
#
PREFIX?=/usr
DESTDIR?=
	
all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f taztank $(DESTDIR)$(PREFIX)/bin

install-files:
	cp -a files/var $(DESTDIR)/
	chmod 0600 -p $(DESTDIR)/var/spool/cron/crontabs/root
	cp -a files/etc $(DESTDIR)/

clean:
	rm -rf _pkg
