#!/bin/sh
# Content negotiation for SliTaz Network
#

IFS=","
for lang in $HTTP_ACCEPT_LANGUAGE; do
	lang=${lang%;*} lang=${lang# } lang=${lang%-*}
	[ -d "$lang" ] &&  break
done
unset IFS
[ -d "$lang" ] || lang="en"

echo "Location: $lang/"
echo ""

exit 0
