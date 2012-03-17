# Makefile for SliTaz mirror.
# Check the README for more information.
#

PREFIX?=/usr

all:

install:
	install -m 0644 files/etc/lighttpd/vhosts.conf /etc/lighttpd
	install -m 0644 files/etc/rsyncd.* /etc

uninstall:
	rm -f /etc/lighttpd/vhosts.conf
	rm -f /etc/rsyncd.*
