#!/bin/sh
#
#. /usr/lib/slitaz/httphelper.sh
#header
echo "Content-Type: text/html"
echo ""

cat header.html

cat << EOT

<h2>SliTaz i486 platform</h2>

<p>
	SliTaz i486: stable, cooking, undiguest + backport
</p>
<p>
	SliTaz i486: <a href="/cooker.cgi?pkg=slitaz-toolchain">toolchain</a>
</p>

<pre>
Version  : <a href="stable">stable</a>
</pre>

<pre>
Version  : <a href="cooker.cgi">cooking</a>
</pre>

<pre>
Version  : <a href="undigest/">undigest</a>
</pre>

</div>
</body>
</html>
EOT

exit 0
