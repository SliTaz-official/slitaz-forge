# Makefile for Chub tools.
# Check the README for more information.
#

PREFIX?=/usr

all:

install:
	install -m 0777 -d /var/spool/cron/crontabs
	install -m 0777 chub $(PREFIX)/bin
	install -m 0644 files/etc/lighttpd/vhosts.conf /etc/lighttpd
	install -m 0644 files/var/spool/cron/crontabs/root \
		/var/spool/cron/crontabs

uninstall:
	rm -f $(PREFIX)/bin/chub
	rm -f /etc/lighttpd/vhosts.conf
	rm -f /var/spool/cron/crontabs/root
