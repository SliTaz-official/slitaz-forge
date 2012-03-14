# Makefile for Tank tools.
# Check the README for more information.
#
PREFIX?=/usr
DESTDIR?=
	
all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/share
	cp -f tank $(DESTDIR)$(PREFIX)/bin
	cp -a files/usr/share/tank $(DESTDIR)$(PREFIX)/share
	cp -a files/var $(DESTDIR)/
	chmod 0600 -p $(DESTDIR)/var/spool/cron/crontabs/root
	cp -a files/etc $(DESTDIR)/
	cp -a files/usr $(DESTDIR}/
	/etc/init.d/crond restart

uninstall:
	rm -f /usr/bin/tank
	rm -rf /usr/share/tank
	
clean:
	rm -rf _pkg
