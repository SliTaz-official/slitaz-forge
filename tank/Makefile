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
	cp files/usr/share/tank $(DESTDIR)$(PREFIX)/share

install-files:
	cp -a files/var $(DESTDIR)/
	chmod 0600 -p $(DESTDIR)/var/spool/cron/crontabs/root
	cp -a files/etc $(DESTDIR)/
	cp -a files/usr $(DESTDIR}/

# Used to switc from taztank to tank (shorted :-)
uninstill:
	rm -f /usr/bin/taztank
	rm -f /usr/bin/tank
	rm -rf /usr/share/taztank
	rm -rf /usr/share/tank
	
clean:
	rm -rf _pkg
