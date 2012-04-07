# Makefile for Tank tools.
# Check the README for more information.
#
PREFIX?=/usr
DESTDIR?=
WEB?=/home/slitaz/www

all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/share \
		$(WEB)/tank/log/rrd \
		$(WEB)/tank/images/rrd
	cp -f tank $(DESTDIR)$(PREFIX)/bin
	cp -a files/var $(DESTDIR)/
	chmod 0600 $(DESTDIR)/var/spool/cron/crontabs/root
	cp -a files/etc $(DESTDIR)/
	cp -a files/usr/bin $(DESTDIR)/
	/etc/init.d/crond restart
	/etc/init.d/lighttpd restart

uninstall:
	rm -f $(PREFIX)/bin/tank
	rm -rf $(PREFIX)/share/tank
	rm -rf /etc/awstats/*.slitaz.org.conf
