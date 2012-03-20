# Makefile for SliTaz mirror.
# Check the README for more information.
#

PREFIX?=/usr
VHOSTS?=/var/www

TINY=$(VHOSTS)/pizza/tiny
REPOS=/home/slitaz/repos

all:

install:
	install -m 0644 files/etc/lighttpd/vhosts.conf /etc/lighttpd
	install -m 0644 files/etc/rsyncd.* /etc
	install -m 0755 mirror $(PREFIX)/bin 

uninstall:
	rm -f /etc/lighttpd/vhosts.conf
	rm -f /etc/rsyncd.*
	rm -f $(PREFIX)/bin/mirror
