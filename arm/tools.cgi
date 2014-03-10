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
			spi) cat ${hgsat}/rpi/README ;;
			*) echo "No README file for: $(GET tool)" ;;
		esac
		echo '</pre>'
		html_footer ;;
	*\ pkgs\ *)
		# TODO: link packages and add link to raw lists
		title="- Packages"
		count="$(cat $pkgs/packages.list | wc -l)"
		html_header "Packages"
		echo "<h2>Packages: $count</h2>"
		IFS="|"
		cat $pkgs/packages.desc | while read pkg vers desc web deps
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
