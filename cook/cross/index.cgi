#!/bin/sh
#
#. /usr/lib/slitaz/httphelper
#header
echo "Content-Type: text/html"
echo ""

cat header.html

cat << EOT

<h2>Cooker's</h2>

<p>
	SliTaz is actually ported to the ARM platform and work is on the stove
	for the x86_64 architecture. Please read the Cookutils cross howto for
	more informations.
</p>

<ul>
	<li><a href="arm/">arm</a><li>
	<li><a href="x86_64/">x86_64</a><li>
</ul>

</div>
</body>
</html>
EOT

exit 0
