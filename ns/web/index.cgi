#!/bin/sh

# Get parameters with GET, POST and FILE functions
. /usr/bin/httpd_helper.sh

OWNERFILE=name.users
ip="$(GET ip)"
[ "$ip" ] || ip=$REMOTE_ADDR
name="$(GET name)"
name="${name%.by.slitaz.org}"
if [ "$name" -a "$REMOTE_USER" ]; then
	header
	addip=yes
	case " $(GET) " in
	*\ remove\ *|*\ delete\ *|*\ wipe\ *)
		addip=
	esac
	case "$name" in
	@*)	echo "$name not allowed. Abort."
		exit 1 ;;
	*\**)	base="${name//\*/}"
		if grep -qs "^[^ ]*${base//./\\.} " $OWNERFILE ; then
			owner="$(sed "/^[^ ]*${base//./\\.} /!d;s/.* //" $OWNERFILE | uniq | xargs echo)"
			if [ "$addip" -o "$owner" != "$REMOTE_USER" ]; then
				echo "$base is already used by $owner. Abort."
				exit 1
			fi
		fi
	esac
	if grep -qs "^$name " $OWNERFILE || grep -qs "^\$name " $OWNERFILE ; then
		owner="$(sed "/^$name /!d;s/.* //" $OWNERFILE)"
		[ "$owner" ] || owner="$(sed "/^\$name /!d;s/.* //" $OWNERFILE)"
		if [ "$owner" != "$REMOTE_USER" ]; then
			echo "$name is already used by $owner. Abort."
			exit 1
		fi
	else
		echo "$name $(date -u) $REMOTE_USER" >> $OWNERFILE
	fi
	[ "$addip" ] || sed -i "/^$name /d;/^\$name /d" $OWNERFILE
	ttl=900
	[ "$(GET ttl)" ] && ttl="$(GET ttl)"
	req="server 127.0.0.1"
	if [ "$(GET mx)" ]; then
		mx="$(GET mx)"
		[ "$mx" ] || mx=$ip
		req="$req
update delete $name.by.slitaz.org MX"
	[ "$addip" ] && req="$req
update add $name.by.slitaz.org $ttl MX 10 $mx"		
	fi
	type="A"
	echo "$ip" | grep -q : && type="AAAA"
	[ "$(GET ns)" ] && type="NS"
	[ "$(GET txt)" ] && type="TXT" && ip="$(GET txt)"
	[ "$(GET cname)" ] && type="CNAME" && ip="$(GET cname)"
	req="$req
update delete $name.by.slitaz.org $type"
	[ "$addip" ] && req="$req
update add $name.by.slitaz.org $ttl $type $ip"
	echo "$req
send" | nsupdate 2>&1
else
	#header "text/html; charset=utf-8"
	cat <<EOT
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SliTaz Name Server</title>
	<meta charset="utf-8" />
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="style.css" />
	<style type="text/css">
	#header h1 {
		margin: 0;
		padding: 8px 0 0 42px;
		width: 250px;
	}
	#logo {
		background: url(/images/logo.png) no-repeat left;
		position: absolute;
		float: left;
		left: 0px;
		top: 0px;
		width: 40px;
		height: 40px;
	}
	pre { font-size: 100%; }
	</style>
</head>
<body>

<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">Home</a>
		<a href="http://bugs.slitaz.org/">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://roadmap.slitaz.org/">Roadmap</a>
		<a href="http://pizza.slitaz.me/">Pizza</a>
		<a href="http://tank.slitaz.org/">Tank</a>
	</div>
	<h1><a href="./">SliTaz Name Server</a></h1>
</div>

<!-- Content -->
<div id="content">
<h3>Status</h3>
<p>
There are $(wc -l < $OWNERFILE) records and 
$(sed 's/.* //' $OWNERFILE | sort | uniq | wc -l) users
in the by.slitaz.org domain.</p>
EOT
	if grep -qs " $REMOTE_USER$" $OWNERFILE; then
		cat <<EOT
$REMOTE_USER has $(grep " $REMOTE_USER$" $OWNERFILE | wc -l) names:
<pre>
EOT
		for i in $(grep " $REMOTE_USER$" $OWNERFILE | sed 's/ .*//'); do
			dig @127.0.0.1 $i.by.slitaz.org ANY | grep ^$i
		done
		cat <<EOT
</pre>

Your current IP address is $REMOTE_ADDR
EOT
	fi
	cat <<EOT
<h3>Usage</h3>
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;[&ip=&lt;ip1&gt;][&mx[=&lt;ip2&gt;]]"
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;&remove[&mx]"
</pre>
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;&ns=&lt;ip&gt;"
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;&ns&remove"
</pre>
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;&{txt|cname}=&lt;text&gt;"
$ wget -O - "http://user:pass@ns.slitaz.org/?name=&lt;name&gt;&{txt|cname}&remove"
</pre>
<h3>Examples</h3>
<ul>
<li>
Update myblog.by.slitaz.org with my current IP address.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myblog"
</pre>
</li>
<li>
Update myblog.by.slitaz.org with the IP address 1.2.3.4.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myblog&ip=1.2.3.4"
</pre>
</li>
<li>
Update myblog.by.slitaz.org with the IPv6 address 1:2:3::4:5
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myblog&ip=1:2:3::4:5"
</pre>
</li>
<li>
Remove myblog.by.slitaz.org from the name server.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myblog&remove"
</pre>
</li>
<li>
Update myserver.by.slitaz.org with my current IP address and declare the mail server btw.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myserver&mx"
</pre>
</li>
<li>
Update myserver.by.slitaz.org with my current IP address and use the mail server at 1.2.3.4.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=myserver&mx=1.2.3.4"
</pre>
</pre>
</li>
<li>
The Addams family has got a name server at 1.2.3.4.
<pre>
$ wget -O - "http://user:pass@ns.slitaz.org/?name=*.addams&ns=1.2.3.4"
$ nslookup blog.gomez.addams.by.slitaz.org
Name:      blog.gomez.addams.by.slitaz.org
Address 1: 5.6.7.8
</pre>
</li>
</ul>
</div>

<div id="footer">
	<a href="http://www.slitaz.org/">SliTaz Website</a>
	<a href="index.cgi">Name Server</a>
</div>

</body>
</html>
EOT
fi
