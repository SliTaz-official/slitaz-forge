#!/bin/sh

if [ "$1" == "--stats" ]; then
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
		ls $dir/?/* 2> /dev/null | wc -l
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
Date: $(date '+%a, %d %b %Y %H:%M:%S %z')
Subject: $SUBJECT

Hello $SURNAME,

A $KEYSIZE SliTaz USB key will be reserved for you.
Would you mind confirm the pre-ordering with the following link
http://usbkey.slitaz.org/?confirm=$HASH

Or cancel the registration with the following link
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
