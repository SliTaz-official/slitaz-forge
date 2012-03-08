# Makefile for Chub tools.
# Check the README for more information.
#

PREFIX?=/usr

all:

install:
	install -m 0777 chub $(PREFIX)/bin
	install -m 0644 files/etc/lighttpd/vhosts.conf /etc/lighttpd

uninstall:
	rm -f $(PREFIX)/bin/chub
	rm -f /etc/lighttpd/vhosts.conf
