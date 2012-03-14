#!/bin/sh
# /etc/init.d/local.sh - Local startup commands.
# All commands here will be executed at boot time.
#
. /etc/init.d/rc.functions

echo "Starting local startup commands... "
rdate -s tick.greyware.com
for i in /home/slitaz/*/chroot ; do
	chroot $i /etc/init.d/crond start
done
