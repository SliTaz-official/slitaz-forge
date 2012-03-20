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
	install -m 0644 info/*.php $(VHOSTS)/mirror-info
	install -m 0644 info/bin/* $(VHOSTS)/mirror-info/bin

install-tiny:
	cp -a $(REPOS)/slitaz-pizza/php/tiny $(TINY)

uninstall:
	rm -f /etc/lighttpd/vhosts.conf
	rm -f /etc/rsyncd.*
