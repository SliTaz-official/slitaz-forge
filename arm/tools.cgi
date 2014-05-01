#!/bin/sh
#
# SliTaz ARM CGI Tools.
#
# Copyright (C) 2014 SliTaz ARM - BSD License
# Author: Christophe Lincoln <pankso@slitaz.org>
#
. /usr/lib/slitaz/httphelper.sh

repos="/home/slitaz/repos"
pkgs="/home/slitaz/cooking/arm/packages"
mirror="http://cook.slitaz.org/cross/arm/packages/"
hgsat="$repos/slitaz-arm"
hgcook="$repos/cookutils"

#
# Functions
#

# Usage: html_header "title"
html_header() {
	cat header.html | sed s"/_TITLE_/$1/"
}

html_footer() {
	cat << EOT
<!-- Close content -->
</div>

<div id="footer">
	&copy; $(date +%Y) - <a href="http://www.slitaz.org/">SliTaz GNU/Linux</a>
</div>

</body>
</html>
EOT
}

#
# Handle GET actions
#

case " $(GET) " in
	*\ doc\ *)
		header
		html_header "$(GET tool)"
		echo '<pre>'
		case "$(GET tool)" in
			cook) cat ${hgcook}/README ;;
			cross) cat ${hgcook}/doc/cross.txt ;;
			sat) cat ${hgsat}/README ;;
			sat-rpi) cat ${hgsat}/rpi/README ;;
			*) echo "No README file for: $(GET tool)" ;;
		esac
		echo '</pre>'
		html_footer ;;
	
	*\ micronews\ *)
		header
		html_header "microNews" 
		cat << EOT
<h2>SliTaz ARM &micro;News</h2>
<p>
	Development activity can be seen on: 
	<a href="http://hg.slitaz.org/slitaz-arm">SliTaz ARM Hg repo</a>
</p>
<pre style="line-height: 1.6em;">
$(tac news.txt)
</pre>
EOT
		html_footer ;;
		
	*\ pkgs\ *)
		# TODO: link packages and add link to raw lists
		title="- Packages"
		count="$(cat $pkgs/packages.list | wc -l)"
		header
		html_header "Packages"
		cat << EOT
<h2>Packages: $count</h2>

<pre>
Packages lists : <a href="${mirror%/}/packages.list">packages.list</a> \
- <a href="${mirror%/}/packages.md5">packages.md5</a>
Mirror URL     : <a href="${mirror}">${mirror}</a>
</pre>

<h2>Packages list</h2>
EOT
		IFS="|"
		cat $pkgs/packages.desc| while read pkg vers desc web deps
		do
			vers=${vers# }
			cat << EOT
<p>
	<a href="${mirror%/}/${pkg% }-${vers% }-arm.tazpkg">${pkg% }</a> $vers - $desc
</p>
EOT
		done
		unset IFS
		html_footer ;;
	*)
		header "Content-Type: text/plain"
		echo "Hello World!" ;;
esac

exit 0
