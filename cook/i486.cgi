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
	SliTaz i486 version: stable, cooking, undiguest + backport
</p>

<pre>
Version  : <a href="stable">stable</a>
Cook     : <a href="/stable/?pkg=slitaz-toolchain">toolchain</a>
</pre>

<pre>
Version  : <a href="cooker.cgi">cooking</a>
Cook     : <a href="/cooker.cgi?pkg=slitaz-toolchain">toolchain</a>
</pre>

<pre>
Version  : <a href="undigest/">undigest</a>
</pre>

</div>
</body>
</html>
EOT

exit 0
