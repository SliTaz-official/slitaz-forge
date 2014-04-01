#!/bin/sh
#
#. /usr/lib/slitaz/httphelper.sh
#header
echo "Content-Type: text/html"
echo ""

cat header.html

cat << EOT

<h2>SliTaz Cross Cookers</h2>

<p>
	SliTaz is actually ported to the ARM platform and the x86_64
	architecture can be cross or natively compiled (but not officially
	supported). Please read the Cookutils cross howto for more information.
</p>

<p>
	SliTaz ARM website: <a href="http://arm.slitaz.org">arm.slitaz.org</a>
</p>

<pre>
Arch  : <a href="arm/">arm</a>
Cross : <a href="arm/toolchain.cgi">toolchain</a>
</pre>

<pre>
Arch  : <a href="x86_64/">x86_64</a>
Cross : <a href="x86_64/toolchain.cgi">toolchain</a>
</pre>

</div>
</body>
</html>
EOT

exit 0
