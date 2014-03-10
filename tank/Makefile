# Makefile for Tank tools.
# Check the README for more information.
#
PREFIX?=/usr
DESTDIR?=
WEB?=/home/slitaz/www

all:

install:
	mkdir -p \
		$(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/share \
		$(WEB)/tank/log/rrd \
		$(WEB)/tank/images/rrd
	
	cp -f tank $(DESTDIR)$(PREFIX)/bin
	cp -a files/* $(DESTDIR)/
	chmod 0600 $(DESTDIR)/var/spool/cron/crontabs/root
	
	/etc/init.d/crond restart
	/etc/init.d/lighttpd restart
