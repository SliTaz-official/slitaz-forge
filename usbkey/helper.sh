#!/bin/sh

if [ "$1" = "--stats" ]; then
	dir=$(dirname $0)/$2
	if [ -n "$3" ]; then
		sed 's/.*"\([0-9]* Gb\)".*/\1/' $dir/?/* | sort | awk '{
	if ($0 != last && last != "") {
		print last " : " n
		n = 0
	}
	last = $0
	n++
}
END {
	print last " : " n
}'
	else
		sed '/"count";s:1:/!d;s/.*"count";s:1:"\([0-9]*\)";.*/\1/' $dir/?/* | \
			awk 'BEGIN { n=0 }{ n+=$0 } END { print n }'
	fi
	exit	
fi

DOMAIN="slitaz.org"
SERVER="127.0.0.1"
SUBJECT="usbkey.slitaz.org confirmation"
BCC="pascal.bellard@slitaz.org"

SENDTO="$1"
SURNAME="$2"
KEYSIZE="$3"
HASH="$4"

body()
{
	cat <<EOT
From: usbkey-preorder@$DOMAIN
Reply-To: no-reply@$DOMAIN
To: $SENDTO
Date: $(LC_ALL=C date '+%a, %d %b %Y %H:%M:%S %z')
Subject: $SUBJECT

Hello $SURNAME,

A $KEYSIZE SliTaz USB key has been reserved for you.
Would you mind confirming your pre-order with the following link
http://usbkey.slitaz.org/?confirm=$HASH

Or cancelling the registration with the following link
http://usbkey.slitaz.org/?cancel=$HASH

Thanks,
The SliTaz team.
EOT
}

send()
{
	if [ -x /usr/sbin/sendmail ]; then
		body | /usr/sbin/sendmail $SENDTO
	else
		/usr/bin/nc $SERVER 25 <<EOT
HELO $SERVER
MAIL FROM:<usbkey-preorder@$DOMAIN>
RCPT TO:$SENDTO
DATA
$(body)

.
QUIT
EOT
	fi
}

send
SUBJECT="[bcc of $SENDTO] $SUBJECT"
for SENDTO in $BCC ; do
	send
done
