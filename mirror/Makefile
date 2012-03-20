# Makefile for SliTaz mirror.
# Check the README for more information.
#

PREFIX?=/usr
TINY=/var/www/pizza/tiny
REPOS=/home/slitaz/repos

all:

install:
	install -m 0644 files/etc/lighttpd/vhosts.conf /etc/lighttpd
	install -m 0644 files/etc/rsyncd.* /etc

install-tiny:
	hg pull -u $(REPOS)/slitaz-pizza
	cp -a $(REPOS)/slitaz-pizza/php/tiny $(TINY)

uninstall:
	rm -f /etc/lighttpd/vhosts.conf
	rm -f /etc/rsyncd.*
