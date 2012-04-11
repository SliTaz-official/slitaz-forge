#!/bin/bash
# convert all .po to .mo and install them
for pos in *.po
do
	echo -n ${pos}:
	msgfmt "$pos" -o /usr/share/locale/$(echo $pos | cut -d "." -f 1)/LC_MESSAGES/tazpkg-web.mo
	if [ $? = 0 ]; then echo "ok"; else echo "err"; fi
done
